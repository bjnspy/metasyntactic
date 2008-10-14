package org.metasyntactic.providers;

import org.apache.commons.collections.map.MultiValueMap;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.format.DateTimeFormat;
import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.LookupResult;
import org.metasyntactic.data.*;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.DateUtilities;
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
  private Map<String, Date> synchronizationData;
  private Map<String, Map<String, List<Performance>>> performances;


  public DataProvider(NowPlayingModel model) {
    this.model = model;
    performances = new LinkedHashMap<String, Map<String, List<Performance>>>();
  }


  public void update() {
    Runnable runnable = new Runnable() {
      public void run() { updateBackgroundEntryPoint(); }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, true/*visible*/, false/*low priority*/);
  }


  private void updateBackgroundEntryPoint() {
    final Location location = model.getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        model.getUserLocation());
    final LookupResult result = lookupLocation(location, null);
    lookupMissingFavorites(result);

    saveResult(result);

    Runnable runnable = new Runnable() {
      public void run() { reportResultOnMainThread(result); }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportResultOnMainThread(LookupResult result) {
    if (result.movies.size() > 0 || result.theaters.size() > 0) {
      movies = result.movies;
      theaters = result.theaters;
      synchronizationData = result.synchronizationData;
      performances = result.performances;
//        [self.model onProviderUpdated];
      //      [NowPlayingAppDelegate refresh:YES];
    }
  }


  private LookupResult lookupLocation(Location location, Collection<String> theaterNames) {
    if (isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    String country = isNullOrEmpty(location.getCountry()) ?
        Locale.getDefault().getCountry() : location.getCountry();

    int days = Days.daysBetween(new DateTime(new Date()), new DateTime(model.getSearchDate())).getDays();
    days = min(max(days, 0), 7);

    String address =
        "http://metaboxoffice2.appspot.com/LookupTheaterListings2?country=" + country +
            "&language=" + Locale.getDefault().getLanguage() +
            "&day=" + days +
            "&format=pb" +
            "&latitude=" + (int) (location.getLatitude() * 1000000) +
            "&longitude=" + (int) (location.getLongitude() * 1000000);

    byte[] data = NetworkUtilities.download(address, true);
    if (data == null) {
      return null;
    }

    try {
      NowPlaying.TheaterListingsProto theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);

      return processTheaterListings(theaterListings, location, theaterNames);
    }
    catch (Exception e) {
    }

    return null;
  }


  private Map<String, Movie> processMovies(List<NowPlaying.MovieProto> movies) {
    Map<String, Movie> movieIdToMovieMap = new LinkedHashMap<String, Movie>();

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
        releaseDate = DateTimeFormat.forPattern("yyyy-MM-dd").parseDateTime(releaseDateString).toDate();
      }

      String imdbAddress = null;
      if (!isNullOrEmpty(movieProto.getIMDbUrl())) {
        imdbAddress = "http://www.imdb.com/title/" + movieProto.getIMDbUrl();
      }

      Movie movie = new Movie(identifier, title, rating, length, releaseDate, poster, synopsis, "", directors, cast,
          genres);
      movieIdToMovieMap.put(identifier, movie);
    }

    return movieIdToMovieMap;
  }


  private Map<String, List<Performance>> processMovieAndShowtimesList(
      List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList,
      Map<String, Movie> movieIdToMovieMap) {
    Map<String, List<Performance>> result = new LinkedHashMap<String, List<Performance>>();


    for (NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto movieAndShowtimes :
        movieAndShowtimesList) {
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
      NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto theaterAndMovieShowtimes,
      List<Theater> theaters,
      Map<String, Map<String, List<Performance>>> performances,
      Map<String, Date> synchronizationData,
      Location originatingLocation,
      Collection<String> theaterNames,
      Map<String, Movie> movieIdToMovieMap) {
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

    List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto.MovieAndShowtimesProto> movieAndShowtimesList =
        theaterAndMovieShowtimes.getMovieAndShowtimesList();

    Map<String, List<Performance>> movieToShowtimesMap =
        processMovieAndShowtimesList(movieAndShowtimesList, movieIdToMovieMap);

    synchronizationData.put(name, DateUtilities.getToday());

    if (movieToShowtimesMap.isEmpty()) {
      // no showtime information available.  fallback to anything we've
      // stored (but warn the user).

      String performancesFile = getPerformancesFile(name);
      Map<String, List<Performance>> oldPerformances = FileUtilities.readObject(performancesFile);

      if (!oldPerformances.isEmpty()) {
        movieToShowtimesMap = oldPerformances;
        synchronizationData.put(name, synchronizationDateForTheater(name));
      }
    }

    Location location = new Location(latitude, longitude, address, city, state, postalCode, country);

    performances.put(name, movieToShowtimesMap);
    theaters.add(
        new Theater(identifier, name, address, phone, location, originatingLocation, movieToShowtimesMap.keySet()));
  }


  private Object[] processTheaterAndMovieShowtimes(
      List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes,
      Location originatingLocation,
      Collection<String> theaterNames,
      Map<String, Movie> movieIdToMovieMap) {

    List<Theater> theaters = new ArrayList<Theater>();

    Map<String, Map<String, List<Performance>>> performances =
        new LinkedHashMap<String, Map<String, List<Performance>>>();

    Map<String, Date> synchronizationData = new LinkedHashMap<String, Date>();

    for (NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto proto : theaterAndMovieShowtimes) {
      processTheaterAndMovieShowtimes(proto, theaters, performances, synchronizationData,
          originatingLocation, theaterNames, movieIdToMovieMap);
    }

    return new Object[]{theaters, performances, synchronizationData,};
  }


  private LookupResult processTheaterListings(NowPlaying.TheaterListingsProto element, Location originatingLocation,
                                              Collection<String> theaterNames) {
    List<NowPlaying.MovieProto> movieProtos = element.getMoviesList();
    List<NowPlaying.TheaterListingsProto.TheaterAndMovieShowtimesProto> theaterAndMovieShowtimes =
        element.getTheaterAndMovieShowtimesList();
    Map<String, Movie> movieIdToMovieMap = processMovies(movieProtos);

    Object[] theatersAndPerformances = processTheaterAndMovieShowtimes(theaterAndMovieShowtimes,
        originatingLocation, theaterNames, movieIdToMovieMap);

    List<Movie> movies = new ArrayList<Movie>(movieIdToMovieMap.values());
    List<Theater> theaters = (List<Theater>) theatersAndPerformances[0];
    Map<String, Map<String, List<Performance>>> performances =
        (Map<String, Map<String, List<Performance>>>) theatersAndPerformances[1];
    Map<String, Date> synchronizationData =
        (Map<String, Date>) theatersAndPerformances[2];

    return new LookupResult(movies, theaters, performances, synchronizationData);
  }


  private String getMoviesFile() {
    return new File(Application.performancesDirectory, "Movies").getAbsolutePath();
  }


  private String getTheatersFile() {
    return new File(Application.performancesDirectory, "Theaters").getAbsolutePath();
  }


  private String getSynchronizationFile() {
    return new File(Application.performancesDirectory, "Synchronization").getAbsolutePath();
  }


  private String getLastLookupDateFile() {
    return new File(Application.performancesDirectory, "lastLookupDate").getAbsolutePath();
  }


  private Date getLastLookupDate() {
    File file = new File(getLastLookupDateFile());
    if (!file.exists()) {
      return null;
    }

    return new Date(file.lastModified());
  }


  private void setLastLookupDate() {
    FileUtilities.writeObject("", getLastLookupDateFile());
  }


  private void setStale() {
    new File(getLastLookupDateFile()).delete();
  }


  private List<Movie> loadMovies() {
    List<Movie> movies = FileUtilities.readObject(getMoviesFile());
    if (movies == null) {
      return Collections.emptyList();
    }
    return movies;
  }


  private List<Movie> getMovies() {
    if (movies == null) {
      movies = loadMovies();
    }

    return movies;
  }


  private Map<String, Date> loadSynchronizationData() {
    Map<String, Date> result = FileUtilities.readObject(getSynchronizationFile());
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


  private String getPerformancesFile(String theaterName, String parentFolder) {
    return new File(parentFolder, FileUtilities.sanitizeFileName(theaterName)).getAbsolutePath();
  }


  private String getPerformancesFile(String theaterName) {
    return getPerformancesFile(theaterName, Application.performancesDirectory);
  }


  private void saveResult(LookupResult result) {
    if (result.movies.size() > 0 || result.theaters.size() > 0) {
      FileUtilities.writeObject(result.movies, getMoviesFile());
      FileUtilities.writeObject(result.theaters, getTheatersFile());
      FileUtilities.writeObject(result.synchronizationData, getSynchronizationFile());

      String tempFolder = Application.tempDirectory;
      for (String theaterName : result.performances.keySet()) {
        Map<String, List<Performance>> value = result.performances.get(theaterName);
        FileUtilities.writeObject(value, getPerformancesFile(theaterName, tempFolder));
      }

      Application.deleteDirectory(Application.performancesDirectory);
      new File(tempFolder).renameTo(new File(Application.performancesDirectory));
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


  public Date synchronizationDateForTheater(String theaterName) {
    return getSynchronizationData().get(theaterName);
  }
}
