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
import org.metasyntactic.Constants;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.activities.R;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.time.Days;
import org.metasyntactic.time.Hours;
import static org.metasyntactic.utilities.CollectionUtilities.isEmpty;
import org.metasyntactic.utilities.DateUtilities;
import org.metasyntactic.utilities.ExceptionUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import static java.lang.Math.max;
import static java.lang.Math.min;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

public class DataProvider {
  public enum State {
    Started,
    Updating,
    Finished
  }

  private final Object lock = new Object();
  private final NowPlayingModel model;
  private List<Movie> movies;
  private List<Theater> theaters;
  private Map<String, Date> synchronizationData;
  private Map<String, Map<String, List<Performance>>> performances;
  private boolean shutdown;
  private State state;

  public DataProvider(final NowPlayingModel model) {
    this.model = model;
    performances = new HashMap<String, Map<String, List<Performance>>>();
    state = State.Started;
  }

  public void onLowMemory() {
    movies = null;
    theaters = null;
    synchronizationData = null;
    performances = null;
  }

  public void update() {
    final List<Movie> localMovies = getMovies();
    final List<Theater> localTheaters = getTheaters();
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(localMovies, localTheaters);
      }
    };
    state = State.Updating;
    ThreadingUtilities.performOnBackgroundThread("Update Provider", runnable, lock, true/* visible */);
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

  private void updateBackgroundEntryPoint(final Iterable<Movie> currentMovies, final List<Theater> currentTheaters) {
    updateBackgroundEntryPointWorker(currentMovies, currentTheaters);
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        model.getService().sendBroadcast(new Intent(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOADED));
        model.updateSecondaryCaches();
      }
    });
  }

  private void broadcastUpdate(final int id) {
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        final Context context = model.getService();
        if (context != null) {
          final String message = context.getResources().getString(id);
          final Intent intent = new Intent(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS).putExtra("message", message);
          context.sendBroadcast(intent);
        }
      }
    });
  }

  private void updateBackgroundEntryPointWorker(final Iterable<Movie> currentMovies, final List<Theater> currentTheaters) {
    if (isUpToDate()) {
      return;
    }
    if (shutdown) {
      return;
    }

    // LogUtilities.i("DEBUG", "Started downloadUserLocation trace");
    // Debug.startMethodTracing("downloadUserLocation", 50000000);
    long start = System.currentTimeMillis();
    broadcastUpdate(R.string.finding_location);
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(model.getUserAddress());
    LogUtilities.logTime(DataProvider.class, "Get User Location", start);
    // Debug.stopMethodTracing();
    // LogUtilities.i("DEBUG", "Stopped downloadUserLocation trace");
    if (location == null) {
      // this should be impossible. we only update if the user has entered a
      // valid location
      return;
    }
    start = System.currentTimeMillis();
    if (shutdown) {
      return;
    }
    final LookupResult result = lookupLocation(location, null);
    LogUtilities.logTime(DataProvider.class, "Lookup Location", start);
    if (result == null || isEmpty(result.getMovies()) || isEmpty(result.getTheaters())) {
      return;
    }
    start = System.currentTimeMillis();
    if (shutdown) {
      return;
    }
    addMissingData(result, location, currentMovies, currentTheaters);
    LogUtilities.logTime(DataProvider.class, "Add missing data", start);

    start = System.currentTimeMillis();
    broadcastUpdate(R.string.finding_favorites);
    if (shutdown) {
      return;
    }
    lookupMissingFavorites(result);
    LogUtilities.logTime(DataProvider.class, "Lookup Missing Theaters", start);

    reportResult(result);
    saveResult(result);
  }

  private void addMissingData(final LookupResult result, final Location location, final Iterable<Movie> currentMovies,
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
    final Collection<String> existingMovieTitles = new LinkedHashSet<String>();
    for (final Movie movie : result.getMovies()) {
      existingMovieTitles.add(movie.getCanonicalTitle());
    }
    final Collection<Theater> missingTheaters = new LinkedHashSet<Theater>(currentTheaters);
    missingTheaters.removeAll(result.getTheaters());
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
      final Date syncDate = synchronizationDateForTheater(theater);
      if (Math.abs(syncDate.getTime() - new Date().getTime()) > Constants.FOUR_WEEKS) {
        continue;
      }
      result.getPerformances().put(theater.getName(), oldPerformances);
      result.getSynchronizationData().put(theater.getName(), syncDate);
      result.getTheaters().add(theater);
      addMissingMovies(oldPerformances, result, existingMovieTitles, currentMovies);
    }
  }

  @SuppressWarnings("unchecked")
  private void lookupMissingFavorites(final LookupResult lookupResult) {
    if (lookupResult == null) {
      return;
    }
    final Collection<FavoriteTheater> favoriteTheaters = model.getFavoriteTheaters();
    if (favoriteTheaters.isEmpty()) {
      return;
    }
    final MultiValueMap locationToMissingTheaterNames = new MultiValueMap();
    for (final FavoriteTheater favorite : favoriteTheaters) {
      if (!lookupResult.containsFavorite(favorite)) {
        locationToMissingTheaterNames.put(favorite.getOriginatingLocation(), favorite.getName());
      }
    }
    final Collection<String> movieTitles = new LinkedHashSet<String>();
    for (final Movie movie : lookupResult.getMovies()) {
      movieTitles.add(movie.getCanonicalTitle());
    }
    for (final Location location : (Set<Location>)locationToMissingTheaterNames.keySet()) {
      final Collection<String> theaterNames = locationToMissingTheaterNames.getCollection(location);
      final LookupResult favoritesLookupResult = lookupLocation(location, theaterNames);
      if (favoritesLookupResult == null) {
        continue;
      }
      lookupResult.getTheaters().addAll(favoritesLookupResult.getTheaters());
      lookupResult.getPerformances().putAll(favoritesLookupResult.getPerformances());
      // the theater may refer to movies that we don't know about.
      for (final Map.Entry<String, Map<String, List<Performance>>> stringMapEntry : favoritesLookupResult.getPerformances().entrySet()) {
        addMissingMovies(stringMapEntry.getValue(), lookupResult, movieTitles, favoritesLookupResult.getMovies());
      }
    }
  }

  private static void addMissingMovies(final Map<String, List<Performance>> performances, final LookupResult result,
      final Collection<String> existingMovieTitles, final Iterable<Movie> currentMovies) {
    if (isEmpty(performances)) {
      return;
    }
    for (final String movieTitle : performances.keySet()) {
      if (!existingMovieTitles.contains(movieTitle)) {
        existingMovieTitles.add(movieTitle);
        for (final Movie movie : currentMovies) {
          if (movie.getCanonicalTitle().equals(movieTitle)) {
            result.getMovies().add(movie);
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
    movies = result.getMovies();
    theaters = result.getTheaters();
    synchronizationData = result.getSynchronizationData();
    performances = result.getPerformances();
    NowPlayingApplication.refresh(true);
  }

  private LookupResult lookupLocation(final Location location, final Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }
    final String country = isNullOrEmpty(location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();
    int days = Days.daysBetween(DateUtilities.getToday(), model.getSearchDate());
    days = min(max(days, 0), 7);
    final String address = "http://" + NowPlayingApplication.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&postalcode=" + location
    .getPostalCode() + "&language=" + Locale.getDefault().getLanguage() + "&day=" + days + "&format=pb" + "&latitude=" + (int)(location
        .getLatitude() * 1000000) + "&longitude=" + (int)(location.getLongitude() * 1000000) + "&device=android";
    final byte[] data = NetworkUtilities.download(address, true);
    if (data == null) {
      return null;
    }

    broadcastUpdate(R.string.searching_location);
    final NowPlaying.TheaterListingsProto theaterListings;
    try {
      // LogUtilities.i("DEBUG", "Started parse from trace");
      // Debug.startMethodTracing("parse_from", 50000000);
      theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
      // Debug.stopMethodTracing();
      // LogUtilities.i("DEBUG", "Stopped parse from trace");
    } catch (final InvalidProtocolBufferException e) {
      ExceptionUtilities.log(DataProvider.class, "lookupLocation", e);
      return null;
    }
    // LogUtilities.i("DEBUG", "Started processListings trace");
    // Debug.startMethodTracing("processListings", 50000000);
    // Debug.stopMethodTracing();
    // LogUtilities.i("DEBUG", "Stopped processListings trace");
    return processTheaterListings(theaterListings, location, theaterNames);
  }

  private final DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

  private Map<String, Movie> processMovies(final Iterable<NowPlaying.MovieProto> movies) {
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
          releaseDate = formatter.parse(releaseDateString);
        } catch (final ParseException e) {
          throw new RuntimeException(e);
        }
      }
      String imdbAddress = "";
      if (!isNullOrEmpty(movieProto.getIMDbUrl())) {
        imdbAddress = "http://www.imdb.com/title/" + movieProto.getIMDbUrl();
      }
      final String poster = "";
      final Movie movie = new Movie(identifier, title, rating, length, imdbAddress, releaseDate, poster, synopsis, "", directors, cast, genres);
      movieIdToMovieMap.put(identifier, movie);
    }
    return movieIdToMovieMap;
  }

  private static Map<String, List<Performance>> processMovieAndShowtimesList(
      final Iterable<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList,
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

  private static List<String> processTimes(final Iterable<NowPlaying.ShowtimeProto> showtimes) {
    /*
     * if (false) { if (showtimes.size() == 0) { return Collections.emptyList();
     * } if (is24HourTime(showtimes)) { // return process24HourTimes(showtimes);
     * } else { // return process12HourTimes(showtimes); } }
     */

    final List<String> result = new ArrayList<String>();

    for (final NowPlaying.ShowtimeProto proto : showtimes) {
      result.add(proto.getTime());
    }

    return result;
  }

  private void processTheaterAndMovieShowtimes(final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto theaterAndMovieShowtimes,
      final Collection<Theater> theaters, final Map<String, Map<String, List<Performance>>> performances, final Map<String, Date> synchronizationData,
      final Location originatingLocation, final Collection<String> theaterNames, final Map<String, Movie> movieIdToMovieMap) {
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
    final String localState = theater.getState();
    final String postalCode = theater.getPostalCode();
    final String country = theater.getCountry();
    final String phone = theater.getPhone();
    final double latitude = theater.getLatitude();
    final double longitude = theater.getLongitude();
    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList = theaterAndMovieShowtimes
    .getMovieAndShowtimesList();
    Map<String, List<Performance>> movieToShowtimesMap = processMovieAndShowtimesList(movieAndShowtimesList, movieIdToMovieMap);
    synchronizationData.put(name, DateUtilities.getToday());
    if (movieToShowtimesMap.isEmpty()) {
      // no showtime information available. fallback to anything we've
      // stored (but warn the user).
      final File performancesFile = getPerformancesFile(name);
      final Map<String, List<Performance>> oldPerformances = FileUtilities.readStringToListOfPersistables(Performance.reader, performancesFile);
      if (!oldPerformances.isEmpty()) {
        movieToShowtimesMap = oldPerformances;
        synchronizationData.put(name, synchronizationDateForTheater(name));
      }
    }
    final Location location = new Location(latitude, longitude, address, city, localState, postalCode, country);
    performances.put(name, movieToShowtimesMap);
    theaters.add(new Theater(identifier, name, address, phone, location, originatingLocation, new HashSet<String>(movieToShowtimesMap.keySet())));
  }

  private LookupResult processTheaterAndMovieShowtimes(
      final Iterable<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes, final Location originatingLocation,
      final Collection<String> theaterNames, final Map<String, Movie> movieIdToMovieMap) {
    final List<Theater> localTheaters = new ArrayList<Theater>();
    final Map<String, Map<String, List<Performance>>> localPerformances = new HashMap<String, Map<String, List<Performance>>>();
    final Map<String, Date> localSynchronizationData = new HashMap<String, Date>();
    for (final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto proto : theaterAndMovieShowtimes) {
      processTheaterAndMovieShowtimes(proto, localTheaters, localPerformances, localSynchronizationData, originatingLocation, theaterNames,
          movieIdToMovieMap);
    }
    return new LookupResult(null, localTheaters, localPerformances, localSynchronizationData);
  }

  private LookupResult processTheaterListings(final NowPlaying.TheaterListingsProto element, final Location originatingLocation,
      final Collection<String> theaterNames) {
    final List<NowPlaying.MovieProto> movieProtos = element.getMoviesList();
    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes = element.getTheaterAndMovieShowtimesList();
    final Map<String, Movie> movieIdToMovieMap = processMovies(movieProtos);
    final LookupResult result = processTheaterAndMovieShowtimes(theaterAndMovieShowtimes, originatingLocation, theaterNames, movieIdToMovieMap);
    final List<Movie> localMovies = new ArrayList<Movie>(movieIdToMovieMap.values());
    return new LookupResult(localMovies, result.getTheaters(), result.getPerformances(), result.getSynchronizationData());
  }

  private static File getMoviesFile() {
    return new File(NowPlayingApplication.dataDirectory, "Movies");
  }

  private static File getTheatersFile() {
    return new File(NowPlayingApplication.dataDirectory, "Theaters");
  }

  private static File getSynchronizationFile() {
    return new File(NowPlayingApplication.dataDirectory, "Synchronization");
  }

  private static File getLastLookupDateFile() {
    return new File(NowPlayingApplication.dataDirectory, "lastLookupDate");
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
    if (movies == null) {
      movies = loadMovies();
    }
    return movies;
  }

  private static Map<String, Date> loadSynchronizationData() {
    final Map<String, Date> result = FileUtilities.readStringToDateMap(getSynchronizationFile());
    if (result == null) {
      return Collections.emptyMap();
    }
    return result;
  }

  private Map<String, Date> getSynchronizationData() {
    if (synchronizationData == null) {
      synchronizationData = loadSynchronizationData();
    }
    return synchronizationData;
  }

  private static File getPerformancesFile(final File parentFolder, final String theaterName) {
    return new File(parentFolder, FileUtilities.sanitizeFileName(theaterName));
  }

  private static File getPerformancesFile(final String theaterName) {
    return getPerformancesFile(NowPlayingApplication.performancesDirectory, theaterName);
  }

  private void saveResult(final LookupResult result) {
    long start = System.currentTimeMillis();
    broadcastUpdate(R.string.downloading_movie_information);
    FileUtilities.writePersistableCollection(result.getMovies(), getMoviesFile());
    LogUtilities.logTime(DataProvider.class, "Saving Movies", start);
    start = System.currentTimeMillis();
    broadcastUpdate(R.string.downloading_theater_information);
    FileUtilities.writePersistableCollection(result.getTheaters(), getTheatersFile());
    LogUtilities.logTime(DataProvider.class, "Saving Theaters", start);
    start = System.currentTimeMillis();
    FileUtilities.writeStringToDateMap(result.getSynchronizationData(), getSynchronizationFile());
    LogUtilities.logTime(DataProvider.class, "Saving Sync Data", start);
    start = System.currentTimeMillis();
    final File tempFolder = new File(NowPlayingApplication.tempDirectory, "DPT" + Math.random());
    tempFolder.mkdirs();

    broadcastUpdate(R.string.downloading_local_performances);
    for (final Map.Entry<String, Map<String, List<Performance>>> entry : result.getPerformances().entrySet()) {
      final Map<String, List<Performance>> value = entry.getValue();
      FileUtilities.writeStringToListOfPersistables(value, getPerformancesFile(tempFolder, entry.getKey()));
    }
    NowPlayingApplication.deleteDirectory(NowPlayingApplication.performancesDirectory);
    tempFolder.renameTo(NowPlayingApplication.performancesDirectory);
    LogUtilities.logTime(DataProvider.class, "Saving Performances", start);
    // this has to happen last.
    setLastLookupDate();
  }

  private Map<String, List<Performance>> lookupTheaterPerformances(final Theater theater) {
    Map<String, List<Performance>> theaterPerformances = performances.get(theater.getName());
    if (theaterPerformances == null) {
      theaterPerformances = FileUtilities.readStringToListOfPersistables(Performance.reader, getPerformancesFile(theater.getName()));
      performances.put(theater.getName(), theaterPerformances);
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
    if (theaters == null) {
      theaters = loadTheaters();
    }
    return theaters;
  }

  public Date synchronizationDateForTheater(final String theaterName) {
    return getSynchronizationData().get(theaterName);
  }

  public Date synchronizationDateForTheater(final Theater theater) {
    return synchronizationDateForTheater(theater.getName());
  }

  public void shutdown() {
    shutdown = true;
  }

  public static void markOutOfDate() {
    getLastLookupDateFile().delete();
  }

  public State getState() {
    return state;
  }

  public boolean isStale(final Theater theater) {
    final Date date = synchronizationDateForTheater(theater);
    if (date == null) {
      return false;
    }

    return !DateUtilities.isToday(date);
  }
}
