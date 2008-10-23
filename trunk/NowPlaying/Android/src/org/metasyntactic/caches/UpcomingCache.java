package org.metasyntactic.caches;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.metasyntactic.Application;
import org.metasyntactic.Constants;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.XmlUtilities;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.w3c.dom.Element;

import java.io.File;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class UpcomingCache {
  private final Object lock = new Object();
  private static int identifier;

  private final DateTimeFormatter formatter = DateTimeFormat.forPattern("EEE, d MMM yyyy HH:mm:ss Z");

  private String hash;
  private List<Movie> movies;
  private Map<String, String> studioKeys;
  private Map<String, String> titleKeys;


  private File hashFile() {
    return new File(Application.upcomingDirectory, "Hash");
  }


  private File moviesFile() {
    return new File(Application.upcomingDirectory, "Movies");
  }


  private File studiosFile() {
    return new File(Application.upcomingDirectory, "Studios");
  }


  private File titlesFile() {
    return new File(Application.upcomingDirectory, "Titles");
  }


  private String getHash() {
    if (hash == null) {
      hash = FileUtilities.readObject(hashFile(), "");
    }

    return hash;
  }


  private List<Movie> getMovies() {
    if (movies == null) {
      movies = FileUtilities.<List<Movie>>readObject(moviesFile(), Collections.EMPTY_LIST);
    }

    return movies;
  }


  public void update() {
  	final List<Movie> movies = getMovies();
  	
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, true);
  }


  private void updateBackgroundEntryPoint(List<Movie> oldMovies) {
    Map<String, String> studioKeys = new HashMap<String, String>();
    Map<String, String> titleKeys = new HashMap<String, String>();
    List<Movie> newMovies = new ArrayList<Movie>();

    updateIndex(newMovies, studioKeys, titleKeys);
    
    List<Movie> movies = newMovies.isEmpty() ? oldMovies : newMovies;
    updateDetails(movies, studioKeys, titleKeys);
  }


  private void updateIndex(final List<Movie> movies, final Map<String, String> studioKeys,
                           final Map<String, String> titleKeys) {
    File indexFile = hashFile();
    if (indexFile.exists()) {
      long lastModifiedTime = indexFile.lastModified();

      if (Math.abs(lastModifiedTime - new Date().getTime()) < (3 * Constants.ONE_DAY)) {
        return;
      }
    }

    String localHash = getHash();
    String serverHash_ = NetworkUtilities.downloadString(
        "http://metaboxoffice2.appspot.com/LookupUpcomingListings?q=index&hash=true",
        false/*important*/
    );
    final String serverHash = serverHash_ == null ? "0" : serverHash_;

    if (localHash.equals(serverHash)) {
      return;
    }

    Element resultElement = NetworkUtilities.downloadXml(
        "http://metaboxoffice2.appspot.com/LookupUpcomingListings?q=index",
        false/*important*/
    );

    processResultElement(resultElement, movies, studioKeys, titleKeys);
    if (movies.isEmpty()) {
      return;
    }

    save(serverHash, movies, studioKeys, titleKeys);

    Runnable runnable = new Runnable() {
      public void run() {
        report(serverHash, movies, studioKeys, titleKeys);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void report(String serverHash, List<Movie> movies, Map<String, String> studioKeys,
                      Map<String, String> titleKeys) {
    this.hash = serverHash;
    this.movies = movies;
    this.studioKeys = studioKeys;
    this.titleKeys = titleKeys;
  }


  private void save(String serverHash, List<Movie> movies, Map<String, String> studios, Map<String, String> titles) {
    FileUtilities.writeObject(serverHash, hashFile());
    FileUtilities.writeObject(movies, moviesFile());
    FileUtilities.writeObject(studios, studiosFile());
    FileUtilities.writeObject(titles, titlesFile());
  }


  private void processResultElement(Element resultElement, List<Movie> movies, Map<String, String> studioKeys,
                                    Map<String, String> titleKeys) {
    for (Element movieElement : children(resultElement)) {
      processMovieElement(movieElement, movies, studioKeys, titleKeys);
    }
  }


  private void processMovieElement(Element movieElement, List<Movie> movies, Map<String, String> studioKeys,
                                   Map<String, String> titleKeys) {
    DateTime releaseDate = formatter.parseDateTime(movieElement.getAttribute("date"));
    String poster = movieElement.getAttribute("poster");
    String rating = movieElement.getAttribute("rating");
    String studio = movieElement.getAttribute("studio");
    String title = movieElement.getAttribute("title");
    List<String> directors = processArray(XmlUtilities.element(movieElement, "directors"));
    List<String> cast = processArray(XmlUtilities.element(movieElement, "actors"));
    List<String> genres = processArray(XmlUtilities.element(movieElement, "genres"));
    String studioKey = movieElement.getAttribute("studioKey");
    String titleKey = movieElement.getAttribute("titleKey");

    Movie movie = new Movie("" + identifier++, title, rating, 0, "", releaseDate,
        poster, "", studio, directors, cast, genres);

    movies.add(movie);
    studioKeys.put(movie.getCanonicalTitle(), studioKey);
    titleKeys.put(movie.getCanonicalTitle(), titleKey);
  }


  private List<String> processArray(Element element) {
    List<String> result = new ArrayList<String>();
    for (Element child : children(element)) {
      result.add(child.getAttribute("value"));
    }
    return result;
  }


  private void updateDetails(List<Movie> movies, Map<String, String> studioKeys, Map<String, String> titleKeys) {
    if (movies.isEmpty()) {
      return;
    }

    for (Movie movie : movies) {
      updateDetails(movie, studioKeys.get(movie.getCanonicalTitle()), titleKeys.get(movie.getCanonicalTitle()));
    }
  }


  private void updateDetails(Movie movie, String studioKey, String titleKey) {
    updateImdb(movie);
    updatePoster(movie);
    updateSynopsis(movie, studioKey, titleKey);
    updateTrailers(movie, studioKey, titleKey);
    /*
        [self updateIMDb:movie];
    [self updatePoster:movie];
    [self updateSynopsis:movie studio:studio title:title];
    [self updateTrailers:movie studio:studio title:title];
    [NowPlayingAppDelegate refresh];
     */
  }


  private File getImdbFile(Movie movie) {
    return new File(Application.upcomingImdbDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  private File getPosterFile(Movie movie) {
    return new File(Application.upcomingPostersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  private File getSynopsisFile(Movie movie) {
    return new File(Application.upcomingSynopsesDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  private File getTrailersFile(Movie movie) {
    return new File(Application.upcomingTrailersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  private void updateTrailers(Movie movie, String studioKey, String titleKey) {
    File file = getTrailersFile(movie);
    if (file.exists()) {
      if (Math.abs(file.lastModified() - new Date().getTime()) < (3 * Constants.ONE_DAY)) {
        return;
      }
    }

    String trailersString =
        NetworkUtilities.downloadString(
            "http://metaboxoffice2.appspot.com/LookupTrailerListings?studio=" + studioKey +
            "&name=" + titleKey, false);

    if (StringUtilities.isNullOrEmpty(trailersString)) {
      return;
    }

    String[] trailers = trailersString.split("\n");
    if (trailers.length == 0) {
      return;
    }

    FileUtilities.writeObject(Arrays.asList(trailers), file);

    Application.refresh();
  }


  private void updateSynopsis(Movie movie, String studioKey, String titleKey) {
    File file = getSynopsisFile(movie);
    if (file.exists()) {
      if (Math.abs(file.lastModified() - new Date().getTime()) < Constants.ONE_WEEK) {
        return;
      }
    }

    String synopsis =
        NetworkUtilities.downloadString(
            "http://metaboxoffice2.appspot.com/LookupUpcomingListings?studio=" + studioKey +
                "&name=" + titleKey, false);

    if (StringUtilities.isNullOrEmpty(synopsis) ||
        synopsis.startsWith("No synopsis")) {
      return;
    }

    FileUtilities.writeObject(synopsis, file);

    Application.refresh();
  }


  private void updatePoster(Movie movie) {
    if (StringUtilities.isNullOrEmpty(movie.getPoster())) {
      return;
    }

    File file = getPosterFile(movie);
    if (file.exists()) {
      return;
    }

    byte[] data = NetworkUtilities.download(movie.getPoster(), false);
    if (data == null) {
      return;
    }

    FileUtilities.writeBytes(data, file);

    Application.refresh();
  }


  private void updateImdb(Movie movie) {
    File file = getImdbFile(movie);
    if (file.exists()) {
      return;
    }

    String imdbAddress =
        NetworkUtilities.downloadString(
            "http://metaboxoffice2.appspot.com/LookupIMDbListings?q=" +
                StringUtilities.urlEncode(movie.getCanonicalTitle()), false);

    if (StringUtilities.isNullOrEmpty(imdbAddress)) {
      return;
    }

    FileUtilities.writeObject(imdbAddress, file);

    Application.refresh();
  }
}
