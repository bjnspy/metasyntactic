//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
package org.metasyntactic.providers;

import android.content.Context;
import android.content.Intent;
import com.google.protobuf.InvalidProtocolBufferException;
import org.apache.commons.collections.map.MultiValueMap;
import org.metasyntactic.*;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.data.*;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.time.Days;
import org.metasyntactic.time.Hours;
import static org.metasyntactic.utilities.CollectionUtilities.isEmpty;
import org.metasyntactic.utilities.*;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.io.IOException;
import static java.lang.Math.max;
import static java.lang.Math.min;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DataProvider {
  private final Object lock = new Object();
  private final NowPlayingModel model;
  private List<Movie> movies;
  private List<Theater> theaters;
  private Map<String, Date> synchronizationData;
  private Map<String, Map<String, List<Performance>>> performances;
  private boolean shutdown;

  public DataProvider(final NowPlayingModel model) {
    this.model = model;
    this.performances = new HashMap<String, Map<String, List<Performance>>>();
  }

  public void update() {
    final List<Movie> localMovies = getMovies();
    final List<Theater> localTheaters = getTheaters();
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(localMovies, localTheaters);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Provider", runnable, this.lock, true/* visible */);
  }

  private static boolean isUpToDate() {
    final Date lastLookupDate = getLastLookupDate();
    if (lastLookupDate == null) {
      return false;
    }
    final int days = Days.daysBetween(lastLookupDate, new Date());
    if (days != 0) {
      return false;
    }
    // same date. make sure it's been at least 12 hours
    final int hours = Hours.hoursBetween(lastLookupDate, new Date());
    if (hours > 8) {
      return false;
    }
    return true;
  }

  private void updateBackgroundEntryPoint(final List<Movie> currentMovies, final List<Theater> currentTheaters) {
    updateBackgroundEntryPointWorker(currentMovies, currentTheaters);
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        final Context context = NowPlayingControllerWrapper.tryGetApplicationContext();
        if (context != null) {
          context.sendBroadcast(new Intent(Application.NOW_PLAYING_LOCAL_DATA_DOWNLOADED));
        }
        DataProvider.this.model.updateSecondaryCaches();
      }
    });
  }

  private static void broadcastUpdate(final int id) {
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        final Context context = NowPlayingControllerWrapper.tryGetApplicationContext();
        if (context != null) {
          final String message = context.getResources().getString(id);
          final Intent intent = new Intent(Application.NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS).putExtra("message",
                                                                                                          message);
          context.sendBroadcast(intent);
        }
      }
    });
  }

  private void updateBackgroundEntryPointWorker(final List<Movie> currentMovies, final List<Theater> currentTheaters) {
    if (isUpToDate()) {
      return;
    }
    if (this.shutdown) {
      return;
    }

    // Log.i("DEBUG", "Started downloadUserLocation trace");
    // Debug.startMethodTracing("downloadUserLocation", 50000000);
    long start = System.currentTimeMillis();
    broadcastUpdate(R.string.finding_location);
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(
        this.model.getUserAddress());
    LogUtilities.logTime(DataProvider.class, "Get User Location", start);
    // Debug.stopMethodTracing();
    // Log.i("DEBUG", "Stopped downloadUserLocation trace");
    if (location == null) {
      // this should be impossible. we only update if the user has entered a
      // valid location
      return;
    }
    start = System.currentTimeMillis();
    if (this.shutdown) {
      return;
    }
    final LookupResult result = lookupLocation(location, null);
    LogUtilities.logTime(DataProvider.class, "Lookup Location", start);
    if (result == null || isEmpty(result.movies) || isEmpty(result.theaters)) {
      return;
    }
    start = System.currentTimeMillis();
    if (this.shutdown) {
      return;
    }
    addMissingData(result, location, currentMovies, currentTheaters);
    LogUtilities.logTime(DataProvider.class, "Add missing data", start);

    start = System.currentTimeMillis();
    broadcastUpdate(R.string.finding_favorites);
    if (this.shutdown) {
      return;
    }
    lookupMissingFavorites(result);
    LogUtilities.logTime(DataProvider.class, "Lookup Missing Theaters", start);

    reportResult(result);
    saveResult(result);
  }

  private void addMissingData(final LookupResult result, final Location location, final List<Movie> currentMovies,
                              final List<Theater> currentTheaters) {
    // Ok. so if:
    // a) the user is doing their main search
    // b) we do not find data for a theater that should be showing up
    // c) they're close enough to their last search
    // then we want to give them the old information we have for that
    // theater *as well as* a warning to let them know that it may be
    // out of date.
    //
    // This is to deal with the case where the user is confused because
    // a theater they care about has been filtered out because it didn't
    // report showtimes.
    final Set<String> existingMovieTitles = new LinkedHashSet<String>();
    for (final Movie movie : result.movies) {
      existingMovieTitles.add(movie.getCanonicalTitle());
    }
    final Set<Theater> missingTheaters = new LinkedHashSet<Theater>(currentTheaters);
    missingTheaters.removeAll(result.theaters);
    for (final Theater theater : missingTheaters) {
      if (theater.getLocation().distanceTo(location) > 50) {
        // Not close enough. Consider this a brand new search in a new
        // location. Don't include this old theaters.
        continue;
      }
      // no showtime information available. fallback to anything we've
      // stored (but warn the user).
      final Map<String, List<Performance>> oldPerformances = lookupTheaterPerformances(theater);
      if (isEmpty(oldPerformances)) {
        continue;
      }
      final Date syncDate = synchronizationDateForTheater(theater.getName());
      if (Math.abs(syncDate.getTime() - new Date().getTime()) > Constants.FOUR_WEEKS) {
        continue;
      }
      result.performances.put(theater.getName(), oldPerformances);
      result.synchronizationData.put(theater.getName(), syncDate);
      result.theaters.add(theater);
      addMissingMovies(oldPerformances, result, existingMovieTitles, currentMovies);
    }
  }

  @SuppressWarnings("unchecked")
  private void lookupMissingFavorites(final LookupResult lookupResult) {
    if (lookupResult == null) {
      return;
    }
    final List<FavoriteTheater> favoriteTheaters = NowPlayingModel.getFavoriteTheaters();
    if (favoriteTheaters.isEmpty()) {
      return;
    }
    final MultiValueMap locationToMissingTheaterNames = new MultiValueMap();
    for (final FavoriteTheater favorite : favoriteTheaters) {
      if (!lookupResult.containsFavorite(favorite)) {
        locationToMissingTheaterNames.put(favorite.getOriginatingLocation(), favorite.getName());
      }
    }
    final Set<String> movieTitles = new LinkedHashSet<String>();
    for (final Movie movie : lookupResult.movies) {
      movieTitles.add(movie.getCanonicalTitle());
    }
    for (final Location location : (Set<Location>) locationToMissingTheaterNames.keySet()) {
      final Collection<String> theaterNames = locationToMissingTheaterNames.getCollection(location);
      final LookupResult favoritesLookupResult = lookupLocation(location, theaterNames);
      if (favoritesLookupResult == null) {
        continue;
      }
      lookupResult.theaters.addAll(favoritesLookupResult.theaters);
      lookupResult.performances.putAll(favoritesLookupResult.performances);
      // the theater may refer to movies that we don't know about.
      for (final Map.Entry<String, Map<String, List<Performance>>> stringMapEntry : favoritesLookupResult.performances.entrySet()) {
        addMissingMovies(stringMapEntry.getValue(), lookupResult, movieTitles, favoritesLookupResult.movies);
      }
    }
  }

  private static void addMissingMovies(final Map<String, List<Performance>> performances, final LookupResult result,
                                       final Set<String> existingMovieTitles, final List<Movie> currentMovies) {
    if (isEmpty(performances)) {
      return;
    }
    for (final String movieTitle : performances.keySet()) {
      if (!existingMovieTitles.contains(movieTitle)) {
        existingMovieTitles.add(movieTitle);
        for (final Movie movie : currentMovies) {
          if (movie.getCanonicalTitle().equals(movieTitle)) {
            result.movies.add(movie);
            break;
          }
        }
      }
    }
  }

  private void reportResult(final LookupResult result) {
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        reportResultOnMainThread(result);
      }
    });
  }

  private void reportResultOnMainThread(final LookupResult result) {
    this.movies = result.movies;
    this.theaters = result.theaters;
    this.synchronizationData = result.synchronizationData;
    this.performances = result.performances;
    Application.refresh(true);
  }

  private LookupResult lookupLocation(final Location location, final Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }
    final String country = isNullOrEmpty(
        location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();
    int days = Days.daysBetween(DateUtilities.getToday(), this.model.getSearchDate());
    days = min(max(days, 0), 7);
    final String address = "http://" + Application.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&postalcode=" + location.getPostalCode() + "&language=" + Locale.getDefault().getLanguage() + "&day=" + days + "&format=pb" + "&latitude=" + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location.getLongitude() * 1000000) + "&device=android";
    final byte[] data = NetworkUtilities.download(address, true);
    if (data == null) {
      return null;
    }

    broadcastUpdate(R.string.searching_location);
    final NowPlaying.TheaterListingsProto theaterListings;
    try {
      // Log.i("DEBUG", "Started parse from trace");
      // Debug.startMethodTracing("parse_from", 50000000);
      theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
      // Debug.stopMethodTracing();
      // Log.i("DEBUG", "Stopped parse from trace");
    } catch (final InvalidProtocolBufferException e) {
      ExceptionUtilities.log(DataProvider.class, "lookupLocation", e);
      return null;
    }
    // Log.i("DEBUG", "Started processListings trace");
    // Debug.startMethodTracing("processListings", 50000000);
    final LookupResult result = processTheaterListings(theaterListings, location, theaterNames);
    // Debug.stopMethodTracing();
    // Log.i("DEBUG", "Stopped processListings trace");
    return result;
  }

  private final SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

  private Map<String, Movie> processMovies(final List<NowPlaying.MovieProto> movies) {
    final Map<String, Movie> movieIdToMovieMap = new HashMap<String, Movie>();
    for (final NowPlaying.MovieProto movieProto : movies) {
      final String identifier = movieProto.getIdentifier();
      final String title = movieProto.getTitle();
      final String rating = movieProto.getRawRating();
      final int length = movieProto.getLength();
      final String synopsis = movieProto.getDescription();
      final List<String> genres = Arrays.asList(movieProto.getGenre().replace('_', ' ').split("/"));
      final List<String> directors = movieProto.getDirectorList();
      final List<String> cast = movieProto.getCastList();
      final String releaseDateString = movieProto.getReleaseDate();
      Date releaseDate = null;
      if (releaseDateString != null && releaseDateString.length() == 10) {
        try {
          releaseDate = this.formatter.parse(releaseDateString);
        } catch (final ParseException e) {
          throw new RuntimeException(e);
        }
      }
      String imdbAddress = "";
      if (!isNullOrEmpty(movieProto.getIMDbUrl())) {
        imdbAddress = "http://www.imdb.com/title/" + movieProto.getIMDbUrl();
      }
      final String poster = "";
      final Movie movie = new Movie(identifier, title, rating, length, imdbAddress, releaseDate, poster, synopsis, "",
                                    directors, cast, genres);
      movieIdToMovieMap.put(identifier, movie);
    }
    return movieIdToMovieMap;
  }

  private static Map<String, List<Performance>> processMovieAndShowtimesList(
      final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList,
      final Map<String, Movie> movieIdToMovieMap) {
    final Map<String, List<Performance>> result = new HashMap<String, List<Performance>>();
    for (final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto movieAndShowtimes : movieAndShowtimesList) {
      final String movieId = movieAndShowtimes.getMovieIdentifier();
      final String movieTitle = movieIdToMovieMap.get(movieId).getCanonicalTitle();
      final List<Performance> localPerformances = new ArrayList<Performance>();

      final List<String> times = processTimes(movieAndShowtimes.getShowtimes().getShowtimesList());
      final List<NowPlaying.ShowtimeProto> showtimes = movieAndShowtimes.getShowtimes().getShowtimesList();
      for (int i = 0; i < showtimes.size(); i++) {
        final String time = times.get(i);
        if (time == null) {
          continue;
        }
        String url = showtimes.get(i).getUrl();
        if (url != null && url.startsWith("tid=")) {
          url = "http://www.fandango.com/redirect.aspx?" + url + "&a=11584&source=google";
        }
        final Performance performance = new Performance(time, url);
        localPerformances.add(performance);
      }
      result.put(movieTitle, localPerformances);
    }
    return result;
  }

  private static List<String> processTimes(final List<NowPlaying.ShowtimeProto> showtimes) {
    /*
    if (false) {
      if (showtimes.size() == 0) {
        return Collections.emptyList();
      }
      if (is24HourTime(showtimes)) {
        // return process24HourTimes(showtimes);
      } else {
        // return process12HourTimes(showtimes);
      }
    }
    */

    final List<String> result = new ArrayList<String>();

    for (final NowPlaying.ShowtimeProto proto : showtimes) {
      result.add(proto.getTime());
    }

    return result;
  }

  private void processTheaterAndMovieShowtimes(
      final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto theaterAndMovieShowtimes,
      final List<Theater> theaters, final Map<String, Map<String, List<Performance>>> performances,
      final Map<String, Date> synchronizationData, final Location originatingLocation,
      final Collection<String> theaterNames, final Map<String, Movie> movieIdToMovieMap) {
    final NowPlaying.TheaterProto theater = theaterAndMovieShowtimes.getTheater();
    final String name = theater.getName();
    if (isNullOrEmpty(name)) {
      return;
    }
    if (theaterNames != null && !theaterNames.contains(name)) {
      return;
    }
    final String identifier = theater.getIdentifier();
    final String address = theater.getStreetAddress();
    final String city = theater.getCity();
    final String state = theater.getState();
    final String postalCode = theater.getPostalCode();
    final String country = theater.getCountry();
    final String phone = theater.getPhone();
    final double latitude = theater.getLatitude();
    final double longitude = theater.getLongitude();
    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList = theaterAndMovieShowtimes.getMovieAndShowtimesList();
    Map<String, List<Performance>> movieToShowtimesMap = processMovieAndShowtimesList(movieAndShowtimesList,
                                                                                      movieIdToMovieMap);
    synchronizationData.put(name, DateUtilities.getToday());
    if (movieToShowtimesMap.isEmpty()) {
      // no showtime information available. fallback to anything we've
      // stored (but warn the user).
      final File performancesFile = getPerformancesFile(name);
      final Map<String, List<Performance>> oldPerformances = FileUtilities.readStringToListOfPersistables(
          Performance.reader, performancesFile);
      if (!oldPerformances.isEmpty()) {
        movieToShowtimesMap = oldPerformances;
        synchronizationData.put(name, synchronizationDateForTheater(name));
      }
    }
    final Location location = new Location(latitude, longitude, address, city, state, postalCode, country);
    performances.put(name, movieToShowtimesMap);
    theaters.add(new Theater(identifier, name, address, phone, location, originatingLocation,
                             new HashSet<String>(movieToShowtimesMap.keySet())));
  }

  private LookupResult processTheaterAndMovieShowtimes(
      final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes,
      final Location originatingLocation, final Collection<String> theaterNames,
      final Map<String, Movie> movieIdToMovieMap) {
    final List<Theater> localTheaters = new ArrayList<Theater>();
    final Map<String, Map<String, List<Performance>>> localPerformances = new HashMap<String, Map<String, List<Performance>>>();
    final Map<String, Date> localSynchronizationData = new HashMap<String, Date>();
    for (final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto proto : theaterAndMovieShowtimes) {
      processTheaterAndMovieShowtimes(proto, localTheaters, localPerformances, localSynchronizationData,
                                      originatingLocation, theaterNames, movieIdToMovieMap);
    }
    return new LookupResult(null, localTheaters, localPerformances, localSynchronizationData);
  }

  private LookupResult processTheaterListings(final NowPlaying.TheaterListingsProto element,
                                              final Location originatingLocation,
                                              final Collection<String> theaterNames) {
    final List<NowPlaying.MovieProto> movieProtos = element.getMoviesList();
    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes = element.getTheaterAndMovieShowtimesList();
    final Map<String, Movie> movieIdToMovieMap = processMovies(movieProtos);
    final LookupResult result = processTheaterAndMovieShowtimes(theaterAndMovieShowtimes, originatingLocation,
                                                                theaterNames, movieIdToMovieMap);
    final List<Movie> localMovies = new ArrayList<Movie>(movieIdToMovieMap.values());
    return new LookupResult(localMovies, result.theaters, result.performances, result.synchronizationData);
  }

  private static File getMoviesFile() {
    return new File(Application.dataDirectory, "Movies");
  }

  private static File getTheatersFile() {
    return new File(Application.dataDirectory, "Theaters");
  }

  private static File getSynchronizationFile() {
    return new File(Application.dataDirectory, "Synchronization");
  }

  private static File getLastLookupDateFile() {
    return new File(Application.dataDirectory, "lastLookupDate");
  }

  private static Date getLastLookupDate() {
    final File file = getLastLookupDateFile();
    if (!file.exists()) {
      return new Date(0);
    }
    return new Date(file.lastModified());
  }

  private static void setLastLookupDate() {
    FileUtilities.writeString("", getLastLookupDateFile());
  }

  private static List<Movie> loadMovies() {
    final List<Movie> result = FileUtilities.readPersistableList(Movie.reader, getMoviesFile());
    if (result == null) {
      return Collections.emptyList();
    }

    // hack. ensure no duplicates
    final Map<String, Movie> map = new HashMap<String, Movie>();
    for (final Movie movie : result) {
      map.put(movie.getIdentifier(), movie);
    }

    return new ArrayList<Movie>(map.values());
  }

  public List<Movie> getMovies() {
    if (this.movies == null) {
      this.movies = loadMovies();
    }
    return Collections.unmodifiableList(this.movies);
  }

  private static Map<String, Date> loadSynchronizationData() {
    final Map<String, Date> result = FileUtilities.readStringToDateMap(getSynchronizationFile());
    if (result == null) {
      return Collections.emptyMap();
    }
    return result;
  }

  private Map<String, Date> getSynchronizationData() {
    if (this.synchronizationData == null) {
      this.synchronizationData = loadSynchronizationData();
    }
    return this.synchronizationData;
  }

  private static File getPerformancesFile(final File parentFolder, final String theaterName) {
    return new File(parentFolder, FileUtilities.sanitizeFileName(theaterName));
  }

  private static File getPerformancesFile(final String theaterName) {
    return getPerformancesFile(Application.performancesDirectory, theaterName);
  }

  private static void saveResult(final LookupResult result) {
    long start = System.currentTimeMillis();
    broadcastUpdate(R.string.downloading_movie_information);
    FileUtilities.writePersistableCollection(result.movies, getMoviesFile());
    LogUtilities.logTime(DataProvider.class, "Saving Movies", start);
    start = System.currentTimeMillis();
    broadcastUpdate(R.string.downloading_theater_information);
    FileUtilities.writePersistableCollection(result.theaters, getTheatersFile());
    LogUtilities.logTime(DataProvider.class, "Saving Theaters", start);
    start = System.currentTimeMillis();
    FileUtilities.writeStringToDateMap(result.synchronizationData, getSynchronizationFile());
    LogUtilities.logTime(DataProvider.class, "Saving Sync Data", start);
    start = System.currentTimeMillis();
    final File tempFile;
    try {
      tempFile = File.createTempFile("DPT", "T1" + Math.random());
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
    final File tempDirectory = tempFile.getParentFile();
    final File tempFolder = new File(tempDirectory, "T2" + Math.random());
    tempFolder.mkdirs();

    broadcastUpdate(R.string.downloading_local_performances);
    for (final Map.Entry<String, Map<String, List<Performance>>> entry : result.performances.entrySet()) {
      final Map<String, List<Performance>> value = entry.getValue();
      FileUtilities.writeStringToListOfPersistables(value, getPerformancesFile(tempFolder, entry.getKey()));
    }
    Application.deleteDirectory(Application.performancesDirectory);
    tempFolder.renameTo(Application.performancesDirectory);
    LogUtilities.logTime(DataProvider.class, "Saving Performances", start);
    // this has to happen last.
    setLastLookupDate();
  }

  private Map<String, List<Performance>> lookupTheaterPerformances(final Theater theater) {
    Map<String, List<Performance>> theaterPerformances = this.performances.get(theater.getName());
    if (theaterPerformances == null) {
      theaterPerformances = FileUtilities.readStringToListOfPersistables(Performance.reader,
                                                                         getPerformancesFile(theater.getName()));
      this.performances.put(theater.getName(), theaterPerformances);
    }
    return theaterPerformances;
  }

  public List<Performance> getPerformancesForMovieInTheater(final Movie movie, final Theater theater) {
    final Map<String, List<Performance>> theaterPerformances = lookupTheaterPerformances(theater);
    if (theaterPerformances != null) {
      final List<Performance> result = theaterPerformances.get(movie.getCanonicalTitle());
      if (result != null) {
        return result;
      }
    }
    return Collections.emptyList();
  }

  private static List<Theater> loadTheaters() {
    final List<Theater> result = FileUtilities.readPersistableList(Theater.reader, getTheatersFile());
    if (result == null) {
      return Collections.emptyList();
    }
    return result;
  }

  public List<Theater> getTheaters() {
    if (this.theaters == null) {
      this.theaters = loadTheaters();
    }
    return Collections.unmodifiableList(this.theaters);
  }

  public Date synchronizationDateForTheater(final String theaterName) {
    return getSynchronizationData().get(theaterName);
  }

  public void shutdown() {
    this.shutdown = true;
  }

  public static void markOutOfDate() {
    getLastLookupDateFile().delete();
  }
}
