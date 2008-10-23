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
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;
import org.joda.time.Seconds;
import org.joda.time.format.DateTimeFormat;
import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.*;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.DateUtilities;
import org.metasyntactic.utilities.ExceptionUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import static java.lang.Math.max;
import static java.lang.Math.min;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class DataProvider {
  private final Object lock = new Object();
  private final NowPlayingModel model;

  private List<Movie> movies;
  private List<Theater> theaters;
  private Map<String, DateTime> synchronizationData;
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
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, true/* visible */);
  }


  private boolean isUpToDate() {
    DateTime lastLookupDate = getLastLookupDate();
    // Debug.startMethodTracing("isUpToDateDaysBetween", 1 << 24);
    int days = Days.daysBetween(lastLookupDate, new DateTime()).getDays();
    // Debug.stopMethodTracing();
    if (days != 0) {
      return false;
    }

    // same date. make sure it's been at least 12 hours
    int hours = Hours.hoursBetween(lastLookupDate, new DateTime()).getHours();
    if (hours > 12) {
      return false;
    }

    return true;
  }


  private void updateBackgroundEntryPoint() {
    if (isUpToDate()) {
      return;
    }

    final Location location = model.getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        model.getUserLocation());
    if (location == null) {
      return;
    }

    final LookupResult result = lookupLocation(location, null);
    lookupMissingFavorites(result);

    saveResult(result);

    Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(result);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportResultOnMainThread(LookupResult result) {
    if (result.movies.size() > 0 || result.theaters.size() > 0) {
      movies = result.movies;
      theaters = result.theaters;
      synchronizationData = result.synchronizationData;
      performances = result.performances;
      model.onDataProvidedUpdated();
      // [self.model onProviderUpdated];
      Application.refresh(true);
    }
  }


  private LookupResult lookupLocation(Location location, Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    String country = isNullOrEmpty(location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();

    // Debug.startMethodTracing("lookupLocationDaysBetween", 1 << 24);
    int days = Days.daysBetween(new DateTime(DateUtilities.getToday()), new DateTime(model.getSearchDate())).getDays();
    // Debug.stopMethodTracing();

    days = min(max(days, 0), 7);

    String address = "http://metaboxoffice2.appspot.com/LookupTheaterListings2?country=" + country + "&language="
        + Locale.getDefault().getLanguage() + "&day=" + days + "&format=pb" + "&latitude="
        + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location.getLongitude() * 1000000);

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

    DateTime start = new DateTime();
    LookupResult result = processTheaterListings(theaterListings, location, theaterNames);
    DateTime stop = new DateTime();

    int seconds = Seconds.secondsBetween(start, stop).getSeconds();
    System.out.println(seconds);

    return result;
  }


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
      DateTime releaseDate = null;
      if (releaseDateString != null && releaseDateString.length() == 10) {
        releaseDate = DateTimeFormat.forPattern("yyyy-MM-dd").parseDateTime(releaseDateString);
      }

      String imdbAddress = null;
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
      Map<String, Map<String, List<Performance>>> performances, Map<String, DateTime> synchronizationData,
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
      Map<String, List<Performance>> oldPerformances = FileUtilities.readObject(performancesFile);

      if (!oldPerformances.isEmpty()) {
        movieToShowtimesMap = oldPerformances;
        synchronizationData.put(name, synchronizationDateForTheater(name));
      }
    }

    Location location = new Location(latitude, longitude, address, city, state, postalCode, country);

    performances.put(name, movieToShowtimesMap);
    theaters.add(new Theater(identifier, name, address, phone, location, originatingLocation, new HashSet<String>(
        movieToShowtimesMap.keySet())));
  }


  private Object[] processTheaterAndMovieShowtimes(
      List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes,
      Location originatingLocation, Collection<String> theaterNames, Map<String, Movie> movieIdToMovieMap) {

    List<Theater> theaters = new ArrayList<Theater>();

    Map<String, Map<String, List<Performance>>> performances = new HashMap<String, Map<String, List<Performance>>>();

    Map<String, DateTime> synchronizationData = new HashMap<String, DateTime>();

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
    Map<String, DateTime> synchronizationData = (Map<String, DateTime>) theatersAndPerformances[2];

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


  private DateTime getLastLookupDate() {
    File file = getLastLookupDateFile();
    if (!file.exists()) {
      return new DateTime(0);
    }

    return new DateTime(file.lastModified());
  }


  private void setLastLookupDate() {
    FileUtilities.writeObject("", getLastLookupDateFile());
  }


  private void setStale() {
    getLastLookupDateFile().delete();
  }


  private List<Movie> loadMovies() {
    return FileUtilities.<List<Movie>>readObject(getMoviesFile(), Collections.EMPTY_LIST);
  }


  public List<Movie> getMovies() {
    if (movies == null) {
      movies = loadMovies();
    }

    return movies;
  }


  private Map<String, DateTime> loadSynchronizationData() {
    Map<String, DateTime> result = FileUtilities.readObject(getSynchronizationFile());
    if (result == null) {
      return Collections.emptyMap();
    }
    return result;
  }


  private Map<String, DateTime> getSynchronizationData() {
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
    if (result.movies.size() > 0 || result.theaters.size() > 0) {
      FileUtilities.writeObject(result.movies, getMoviesFile());
      FileUtilities.writeObject(result.theaters, getTheatersFile());
      FileUtilities.writeObject(result.synchronizationData, getSynchronizationFile());

      File tempFolder = new File(Application.tempDirectory.getAbsolutePath());
      for (String theaterName : result.performances.keySet()) {
        Map<String, List<Performance>> value = result.performances.get(theaterName);
        FileUtilities.writeObject(value, getPerformancesFile(tempFolder, theaterName));
      }

      Application.deleteDirectory(Application.performancesDirectory);
      tempFolder.renameTo(Application.performancesDirectory);
      setLastLookupDate();
    }
  }


  Map<String, List<Performance>> lookupTheaterPerformances(Theater theater) {
    Map<String, List<Performance>> theaterPerformances = performances.get(theater.getName());
    if (theaterPerformances == null) {
      theaterPerformances = FileUtilities.readObject(getPerformancesFile(theater.getName()));
      performances.put(theater.getName(), theaterPerformances);
    }
    return theaterPerformances;
  }


  private List<Performance> getPerformances(Theater theater, Movie movie) {
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
    List<Theater> result = FileUtilities.readObject(getTheatersFile());
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


  public DateTime synchronizationDateForTheater(String theaterName) {
    return getSynchronizationData().get(theaterName);
  }
}
