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

import com.google.protobuf.InvalidProtocolBufferException;
import org.apache.commons.collections.map.MultiValueMap;
import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.*;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.time.Days;
import org.metasyntactic.time.Hours;
import org.metasyntactic.utilities.*;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
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

  public DataProvider(final NowPlayingModel model) {
    this.model = model;
    this.performances = new HashMap<String, Map<String, List<Performance>>>();
  }

  public void update() {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Provider", runnable, this.lock, true/* visible */);
  }

  private boolean isUpToDate() {
    final Date lastLookupDate = getLastLookupDate();
    final int days = Days.daysBetween(lastLookupDate, new Date());
    if (days != 0) {
      return false;
    }

    // same date. make sure it's been at least 12 hours
    final int hours = Hours.hoursBetween(lastLookupDate, new Date());
    if (hours > 12) {
      return false;
    }

    return true;
  }

  private void updateBackgroundEntryPoint() {
    if (isUpToDate()) {
      return;
    }

    long start = System.currentTimeMillis();
    final Location location = this.model.getUserLocationCache()
        .downloadUserAddressLocationBackgroundEntryPoint(this.model.getUserLocation());
    LogUtilities.logTime(DataProvider.class, "Get User Location", start);

    if (location == null) {
      return;
    }

    start = System.currentTimeMillis();
    final LookupResult result = lookupLocation(location, null);
    LogUtilities.logTime(DataProvider.class, "Lookup Theaters", start);

    start = System.currentTimeMillis();
    lookupMissingFavorites(result);
    LogUtilities.logTime(DataProvider.class, "Lookup Missing Theaters", start);

    if (result != null && (result.movies != null && result.movies
        .size() > 0 || result.theaters != null && result.theaters.size() > 0)) {
      reportResult(result);
      saveResult(result);
    }
  }

  private void reportResult(final LookupResult result) {
    final Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(result);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportResultOnMainThread(final LookupResult result) {
    this.movies = result.movies;
    this.theaters = result.theaters;
    this.synchronizationData = result.synchronizationData;
    this.performances = result.performances;
    this.model.onDataProvidedUpdated();

    Application.refresh(true);
  }

  private LookupResult lookupLocation(final Location location, final Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    final String country = isNullOrEmpty(location.getCountry())
                           ? Locale.getDefault().getCountry()
                           : location.getCountry();
    int days = Days.daysBetween(DateUtilities.getToday(), this.model.getSearchDate());

    days = min(max(days, 0), 7);

    final String address = "http://" + Application.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&language=" + Locale
        .getDefault()
        .getLanguage() + "&day=" + days + "&format=pb" + "&latitude=" + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location
        .getLongitude() * 1000000);

    final byte[] data = NetworkUtilities.download(address, true);
    if (data == null) {
      return null;
    }

    NowPlaying.TheaterListingsProto theaterListings = null;
    try {
      theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
    } catch (final InvalidProtocolBufferException e) {
      ExceptionUtilities.log(DataProvider.class, "lookupLocation", e);
      return null;
    }

    return processTheaterListings(theaterListings, location, theaterNames);
  }

  private final SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

  private Map<String, Movie> processMovies(final List<NowPlaying.MovieProto> movies) {
    final Map<String, Movie> movieIdToMovieMap = new HashMap<String, Movie>();

    for (final NowPlaying.MovieProto movieProto : movies) {
      final String identifier = movieProto.getIdentifier();
      final String poster = "";
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

      final Movie movie = new Movie(identifier, title, rating, length, imdbAddress, releaseDate, poster, synopsis, "",
                                    directors, cast, genres);
      movieIdToMovieMap.put(identifier, movie);
    }

    return movieIdToMovieMap;
  }

  private Map<String, List<Performance>> processMovieAndShowtimesList(
      final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList,
      final Map<String, Movie> movieIdToMovieMap) {
    final Map<String, List<Performance>> result = new HashMap<String, List<Performance>>();

    for (final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto movieAndShowtimes : movieAndShowtimesList) {
      final String movieId = movieAndShowtimes.getMovieIdentifier();
      final String movieTitle = movieIdToMovieMap.get(movieId).getCanonicalTitle();

      final List<Performance> performances = new ArrayList<Performance>();

      for (final NowPlaying.ShowtimeProto showtime : movieAndShowtimes.getShowtimes().getShowtimesList()) {
        String time = showtime.getTime();
        String url = showtime.getUrl();

        time = Theater.processShowtime(time);

        if (url != null && url.startsWith("m=")) {
          url = "http://iphone.fandango.com/tms.asp?a=11586&" + url;
        }

        final Performance performance = new Performance(time, url);
        performances.add(performance);
      }

      result.put(movieTitle, performances);
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

    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList = theaterAndMovieShowtimes
        .getMovieAndShowtimesList();

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

  private Object[] processTheaterAndMovieShowtimes(
      final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes,
      final Location originatingLocation, final Collection<String> theaterNames,
      final Map<String, Movie> movieIdToMovieMap) {

    final List<Theater> theaters = new ArrayList<Theater>();

    final Map<String, Map<String, List<Performance>>> performances = new HashMap<String, Map<String, List<Performance>>>();

    final Map<String, Date> synchronizationData = new HashMap<String, Date>();

    for (final NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto proto : theaterAndMovieShowtimes) {
      processTheaterAndMovieShowtimes(proto, theaters, performances, synchronizationData, originatingLocation,
                                      theaterNames, movieIdToMovieMap);
    }

    return new Object[]{theaters, performances, synchronizationData,};
  }

  private LookupResult processTheaterListings(final NowPlaying.TheaterListingsProto element,
                                              final Location originatingLocation,
                                              final Collection<String> theaterNames) {
    final List<NowPlaying.MovieProto> movieProtos = element.getMoviesList();
    final List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes = element.getTheaterAndMovieShowtimesList();
    final Map<String, Movie> movieIdToMovieMap = processMovies(movieProtos);

    final Object[] theatersAndPerformances = processTheaterAndMovieShowtimes(theaterAndMovieShowtimes,
                                                                             originatingLocation, theaterNames,
                                                                             movieIdToMovieMap);

    final List<Movie> movies = new ArrayList<Movie>(movieIdToMovieMap.values());
    final List<Theater> theaters = (List<Theater>) theatersAndPerformances[0];
    final Map<String, Map<String, List<Performance>>> performances = (Map<String, Map<String, List<Performance>>>) theatersAndPerformances[1];
    final Map<String, Date> synchronizationData = (Map<String, Date>) theatersAndPerformances[2];

    return new LookupResult(movies, theaters, performances, synchronizationData);
  }

  private File getMoviesFile() {
    return new File(Application.dataDirectory, "Movies");
  }

  private File getTheatersFile() {
    return new File(Application.dataDirectory, "Theaters");
  }

  private File getSynchronizationFile() {
    return new File(Application.dataDirectory, "Synchronization");
  }

  private File getLastLookupDateFile() {
    return new File(Application.dataDirectory, "lastLookupDate");
  }

  private Date getLastLookupDate() {
    final File file = getLastLookupDateFile();
    if (!file.exists()) {
      return new Date(0);
    }

    return new Date(file.lastModified());
  }

  private void setLastLookupDate() {
    FileUtilities.writeString("", getLastLookupDateFile());
  }

  private List<Movie> loadMovies() {
    final List<Movie> result = FileUtilities.readPersistableList(Movie.reader, getMoviesFile());
    if (result == null) {
      return Collections.emptyList();
    }
    return result;
  }

  public List<Movie> getMovies() {
    if (this.movies == null) {
      this.movies = loadMovies();
    }

    return this.movies;
  }

  private Map<String, Date> loadSynchronizationData() {
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

  private File getPerformancesFile(final File parentFolder, final String theaterName) {
    return new File(parentFolder, FileUtilities.sanitizeFileName(theaterName));
  }

  private File getPerformancesFile(final String theaterName) {
    return getPerformancesFile(Application.performancesDirectory, theaterName);
  }

  private void saveResult(final LookupResult result) {
    long start = System.currentTimeMillis();
    FileUtilities.writePersistableCollection(result.movies, getMoviesFile());
    LogUtilities.logTime(DataProvider.class, "Saving Movies", start);

    start = System.currentTimeMillis();
    FileUtilities.writePersistableCollection(result.theaters, getTheatersFile());
    LogUtilities.logTime(DataProvider.class, "Saving Theaters", start);

    start = System.currentTimeMillis();
    FileUtilities.writeStringToDateMap(result.synchronizationData, getSynchronizationFile());
    LogUtilities.logTime(DataProvider.class, "Saving Theaters", start);

    start = System.currentTimeMillis();
    final File tempFolder = new File(Application.tempDirectory, "T" + new Random().nextInt());
    tempFolder.mkdirs();

    for (final String theaterName : result.performances.keySet()) {
      final Map<String, List<Performance>> value = result.performances.get(theaterName);
      FileUtilities.writeStringToListOfPersistables(value, getPerformancesFile(tempFolder, theaterName));
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
      final List<Performance> performances = theaterPerformances.get(movie.getCanonicalTitle());
      if (performances != null) {
        return performances;
      }
    }
    return Collections.emptyList();
  }

  private List<Theater> loadTheaters() {
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
    return this.theaters;
  }

  private void lookupMissingFavorites(final LookupResult lookupResult) {
    if (lookupResult == null) {
      return;
    }

    final List<FavoriteTheater> favoriteTheaters = this.model.getFavoriteTheaters();
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
      for (final String theaterName : favoritesLookupResult.performances.keySet()) {
        for (final String movieTitle : favoritesLookupResult.performances.get(theaterName).keySet()) {
          if (movieTitles.add(movieTitle)) {
            for (final Movie movie : favoritesLookupResult.movies) {
              if (movie.getCanonicalTitle().equals(movieTitle)) {
                lookupResult.movies.add(movie);
                break;
              }
            }
          }
        }
      }
    }
  }

  public Date synchronizationDateForTheater(final String theaterName) {
    return getSynchronizationData().get(theaterName);
  }

  public void shutdown() {
    // NYI
  }
}
