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

  public DataProvider(NowPlayingModel model) {
    this.model = model;
    performances = new HashMap<String, Map<String, List<Performance>>>();
  }

  public void update() {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Provider", runnable, lock, true/* visible */);
  }

  private boolean isUpToDate() {
    Date lastLookupDate = getLastLookupDate();
    int days = Days.daysBetween(lastLookupDate, new Date());
    if (days != 0) {
      return false;
    }

    // same date. make sure it's been at least 12 hours
    int hours = Hours.hoursBetween(lastLookupDate, new Date());
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
    final Location location = model.getUserLocationCache()
        .downloadUserAddressLocationBackgroundEntryPoint(model.getUserLocation());
    LogUtilities.logTime(DataProvider.class, "Get User Location", start);

    if (location == null) {
      return;
    }

    start = System.currentTimeMillis();
    LookupResult result = lookupLocation(location, null);
    LogUtilities.logTime(DataProvider.class, "Lookup Theaters", start);

    start = System.currentTimeMillis();
    lookupMissingFavorites(result);
    LogUtilities.logTime(DataProvider.class, "Lookup Missing Theaters", start);

    if (result != null && ((result.movies != null && result.movies
        .size() > 0) || (result.theaters != null && result.theaters.size() > 0))) {
      reportResult(result);
      saveResult(result);
    }
  }

  private void reportResult(final LookupResult result) {
    Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(result);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportResultOnMainThread(LookupResult result) {
    movies = result.movies;
    theaters = result.theaters;
    synchronizationData = result.synchronizationData;
    performances = result.performances;
    model.onDataProvidedUpdated();

    Application.refresh(true);
  }

  private LookupResult lookupLocation(Location location, Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    String country = isNullOrEmpty(location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();
    int days = Days.daysBetween(DateUtilities.getToday(), model.getSearchDate());

    days = min(max(days, 0), 7);

    String address = "http://" + Application.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&language=" + Locale
        .getDefault()
        .getLanguage() + "&day=" + days + "&format=pb" + "&latitude=" + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location
        .getLongitude() * 1000000);

    byte[] data = NetworkUtilities.download(address, true);
    if (data == null) {
      return null;
    }

    NowPlaying.TheaterListingsProto theaterListings = null;
    try {
      theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
    } catch (InvalidProtocolBufferException e) {
      ExceptionUtilities.log(DataProvider.class, "lookupLocation", e);
      return null;
    }

    return processTheaterListings(theaterListings, location, theaterNames);
  }

  private final SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

  private Map<String, Movie> processMovies(List<NowPlaying.MovieProto> movies) {
    Map<String, Movie> movieIdToMovieMap = new HashMap<String, Movie>();

    for (NowPlaying.MovieProto movieProto : movies) {
      String identifier = movieProto.getIdentifier();
      String poster = "";
      String title = movieProto.getTitle();
      String rating = movieProto.getRawRating();
      int length = movieProto.getLength();
      String synopsis = movieProto.getDescription();
      List<String> genres = Arrays.asList(movieProto.getGenre().replace('_', ' ').split("/"));
      List<String> directors = movieProto.getDirectorList();
      List<String> cast = movieProto.getCastList();
      String releaseDateString = movieProto.getReleaseDate();
      Date releaseDate = null;
      if (releaseDateString != null && releaseDateString.length() == 10) {
        try {
          releaseDate = formatter.parse(releaseDateString);
        } catch (ParseException e) {
          throw new RuntimeException(e);
        }
      }

      String imdbAddress = "";
      if (!isNullOrEmpty(movieProto.getIMDbUrl())) {
        imdbAddress = "http://www.imdb.com/title/" + movieProto.getIMDbUrl();
      }

      Movie movie = new Movie(identifier, title, rating, length, imdbAddress, releaseDate, poster, synopsis, "",
                              directors, cast, genres);
      movieIdToMovieMap.put(identifier, movie);
    }

    return movieIdToMovieMap;
  }

  private Map<String, List<Performance>> processMovieAndShowtimesList(
      List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList,
      Map<String, Movie> movieIdToMovieMap) {
    Map<String, List<Performance>> result = new HashMap<String, List<Performance>>();

    for (NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto movieAndShowtimes : movieAndShowtimesList) {
      String movieId = movieAndShowtimes.getMovieIdentifier();
      String movieTitle = movieIdToMovieMap.get(movieId).getCanonicalTitle();

      List<Performance> performances = new ArrayList<Performance>();

      for (NowPlaying.ShowtimeProto showtime : movieAndShowtimes.getShowtimes().getShowtimesList()) {
        String time = showtime.getTime();
        String url = showtime.getUrl();

        time = Theater.processShowtime(time);

        if (url != null && url.startsWith("m=")) {
          url = "http://iphone.fandango.com/tms.asp?a=11586&" + url;
        }

        Performance performance = new Performance(time, url);
        performances.add(performance);
      }

      result.put(movieTitle, performances);
    }

    return result;
  }

  private void processTheaterAndMovieShowtimes(
      NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto theaterAndMovieShowtimes, List<Theater> theaters,
      Map<String, Map<String, List<Performance>>> performances, Map<String, Date> synchronizationData,
      Location originatingLocation, Collection<String> theaterNames, Map<String, Movie> movieIdToMovieMap) {
    NowPlaying.TheaterProto theater = theaterAndMovieShowtimes.getTheater();
    String name = theater.getName();
    if (isNullOrEmpty(name)) {
      return;
    }

    if (theaterNames != null && !theaterNames.contains(name)) {
      return;
    }

    String identifier = theater.getIdentifier();
    String address = theater.getStreetAddress();
    String city = theater.getCity();
    String state = theater.getState();
    String postalCode = theater.getPostalCode();
    String country = theater.getCountry();
    String phone = theater.getPhone();
    double latitude = theater.getLatitude();
    double longitude = theater.getLongitude();

    List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList = theaterAndMovieShowtimes
        .getMovieAndShowtimesList();

    Map<String, List<Performance>> movieToShowtimesMap = processMovieAndShowtimesList(movieAndShowtimesList,
                                                                                      movieIdToMovieMap);

    synchronizationData.put(name, DateUtilities.getToday());

    if (movieToShowtimesMap.isEmpty()) {
      // no showtime information available. fallback to anything we've
      // stored (but warn the user).

      File performancesFile = getPerformancesFile(name);
      Map<String, List<Performance>> oldPerformances = FileUtilities.readStringToListOfPersistables(Performance.reader,
                                                                                                    performancesFile);

      if (!oldPerformances.isEmpty()) {
        movieToShowtimesMap = oldPerformances;
        synchronizationData.put(name, synchronizationDateForTheater(name));
      }
    }

    Location location = new Location(latitude, longitude, address, city, state, postalCode, country);

    performances.put(name, movieToShowtimesMap);
    theaters.add(new Theater(identifier, name, address, phone, location, originatingLocation,
                             new HashSet<String>(movieToShowtimesMap.keySet())));
  }

  private Object[] processTheaterAndMovieShowtimes(
      List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes,
      Location originatingLocation, Collection<String> theaterNames, Map<String, Movie> movieIdToMovieMap) {

    List<Theater> theaters = new ArrayList<Theater>();

    Map<String, Map<String, List<Performance>>> performances = new HashMap<String, Map<String, List<Performance>>>();

    Map<String, Date> synchronizationData = new HashMap<String, Date>();

    for (NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto proto : theaterAndMovieShowtimes) {
      processTheaterAndMovieShowtimes(proto, theaters, performances, synchronizationData, originatingLocation,
                                      theaterNames, movieIdToMovieMap);
    }

    return new Object[]{theaters, performances, synchronizationData,};
  }

  private LookupResult processTheaterListings(NowPlaying.TheaterListingsProto element, Location originatingLocation,
                                              Collection<String> theaterNames) {
    List<NowPlaying.MovieProto> movieProtos = element.getMoviesList();
    List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes = element
        .getTheaterAndMovieShowtimesList();
    Map<String, Movie> movieIdToMovieMap = processMovies(movieProtos);

    Object[] theatersAndPerformances = processTheaterAndMovieShowtimes(theaterAndMovieShowtimes, originatingLocation,
                                                                       theaterNames, movieIdToMovieMap);

    List<Movie> movies = new ArrayList<Movie>(movieIdToMovieMap.values());
    List<Theater> theaters = (List<Theater>) theatersAndPerformances[0];
    Map<String, Map<String, List<Performance>>> performances = (Map<String, Map<String, List<Performance>>>) theatersAndPerformances[1];
    Map<String, Date> synchronizationData = (Map<String, Date>) theatersAndPerformances[2];

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
    File file = getLastLookupDateFile();
    if (!file.exists()) {
      return new Date(0);
    }

    return new Date(file.lastModified());
  }

  private void setLastLookupDate() {
    FileUtilities.writeString("", getLastLookupDateFile());
  }

  private void setStale() {
    getLastLookupDateFile().delete();
  }

  private List<Movie> loadMovies() {
    List<Movie> result = FileUtilities.readPersistableList(Movie.reader, getMoviesFile());
    if (result == null) {
      return Collections.emptyList();
    }
    return result;
  }

  public List<Movie> getMovies() {
    if (movies == null) {
      movies = loadMovies();
    }

    return movies;
  }

  private Map<String, Date> loadSynchronizationData() {
    Map<String, Date> result = FileUtilities.readStringToDateMap(getSynchronizationFile());
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

  private File getPerformancesFile(File parentFolder, String theaterName) {
    return new File(parentFolder, FileUtilities.sanitizeFileName(theaterName));
  }

  private File getPerformancesFile(String theaterName) {
    return getPerformancesFile(Application.performancesDirectory, theaterName);
  }

  private void saveResult(LookupResult result) {
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
    File tempFolder = new File(Application.tempDirectory, "T" + new Random().nextInt());
    tempFolder.mkdirs();

    for (String theaterName : result.performances.keySet()) {
      Map<String, List<Performance>> value = result.performances.get(theaterName);
      FileUtilities.writeStringToListOfPersistables(value, getPerformancesFile(tempFolder, theaterName));
    }

    Application.deleteDirectory(Application.performancesDirectory);
    tempFolder.renameTo(Application.performancesDirectory);
    LogUtilities.logTime(DataProvider.class, "Saving Performances", start);

    // this has to happen last.
    setLastLookupDate();
  }

  private Map<String, List<Performance>> lookupTheaterPerformances(Theater theater) {
    Map<String, List<Performance>> theaterPerformances = performances.get(theater.getName());
    if (theaterPerformances == null) {
      theaterPerformances = FileUtilities.readStringToListOfPersistables(Performance.reader,
                                                                         getPerformancesFile(theater.getName()));
      performances.put(theater.getName(), theaterPerformances);
    }
    return theaterPerformances;
  }

  public List<Performance> getPerformancesForMovieInTheater(Movie movie, Theater theater) {
    Map<String, List<Performance>> theaterPerformances = lookupTheaterPerformances(theater);
    if (theaterPerformances != null) {
      List<Performance> performances = theaterPerformances.get(movie.getCanonicalTitle());
      if (performances != null) {
        return performances;
      }
    }
    return Collections.emptyList();
  }

  private List<Theater> loadTheaters() {
    List<Theater> result = FileUtilities.readPersistableList(Theater.reader, getTheatersFile());
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

  private void lookupMissingFavorites(LookupResult lookupResult) {
    if (lookupResult == null) {
      return;
    }

    List<FavoriteTheater> favoriteTheaters = model.getFavoriteTheaters();
    if (favoriteTheaters.isEmpty()) {
      return;
    }

    MultiValueMap locationToMissingTheaterNames = new MultiValueMap();

    for (FavoriteTheater favorite : favoriteTheaters) {
      if (!lookupResult.containsFavorite(favorite)) {
        locationToMissingTheaterNames.put(favorite.getOriginatingLocation(), favorite.getName());
      }
    }

    Set<String> movieTitles = new LinkedHashSet<String>();
    for (Movie movie : lookupResult.movies) {
      movieTitles.add(movie.getCanonicalTitle());
    }

    for (Location location : (Set<Location>) locationToMissingTheaterNames.keySet()) {
      Collection<String> theaterNames = locationToMissingTheaterNames.getCollection(location);
      LookupResult favoritesLookupResult = lookupLocation(location, theaterNames);

      if (favoritesLookupResult == null) {
        continue;
      }

      lookupResult.theaters.addAll(favoritesLookupResult.theaters);
      lookupResult.performances.putAll(favoritesLookupResult.performances);

      // the theater may refer to movies that we don't know about.
      for (String theaterName : favoritesLookupResult.performances.keySet()) {
        for (String movieTitle : favoritesLookupResult.performances.get(theaterName).keySet()) {
          if (movieTitles.add(movieTitle)) {
            for (Movie movie : favoritesLookupResult.movies) {
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

  public Date synchronizationDateForTheater(String theaterName) {
    return getSynchronizationData().get(theaterName);
  }
}
