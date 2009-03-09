package org.metasyntactic.caches.dvd;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractMovieCache;
import org.metasyntactic.collections.IdentityHashSet;
import org.metasyntactic.data.DVD;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.DateUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public abstract class AbstractDVDBlurayCache extends AbstractMovieCache {
  private Set<Movie> moviesSet;
  private List<Movie> movies;

  private boolean updated;

  protected AbstractDVDBlurayCache(final NowPlayingModel model) {
    super(model);
    getDirectory().mkdirs();
    getDetailsDirectory().mkdirs();
  }

  protected abstract String getServerAddress();

  protected abstract File getDirectory();

  private File getDetailsDirectory() {
    return new File(getDirectory(), "Details");
  }

  private File getMoviesFile() {
    return new File(getDirectory(), "Movies");
  }

  @Override protected List<File> getCacheDirectories() {
    return Arrays.asList(getDirectory(), getDetailsDirectory());
  }

  private static List<Movie> loadMovies(final File file) {
    final List<Movie> movies = FileUtilities.readPersistableList(Movie.reader, file);
    if (CollectionUtilities.isEmpty(movies)) {
      return Collections.emptyList();
    }

    return movies;
  }

  private List<Movie> loadMovies() {
    return loadMovies(getMoviesFile());
  }

  private void setMovies(final List<Movie> movies) {
    this.movies = movies;
    moviesSet = new IdentityHashSet<Movie>(movies);
  }

  private Object getMovies() {
    if (movies == null) {
      setMovies(loadMovies());
    }

    return movies;
  }

  private Collection<Movie> getMoviesSet() {
    getMovies();
    return moviesSet;
  }

  public void update() {
    if (isNullOrEmpty(model.getUserAddress())) {
      return;
    }

    if (updated) {
      return;
    }
    updated = true;

    final String name = getClass().getSimpleName() + "-Update";
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread(name, runnable, null, true);
  }

  private static List<String> split(final String value) {
    if (isNullOrEmpty(value)) {
      return Collections.emptyList();
    }

    return Arrays.asList(value.split("/"));
  }

  private static final Map<String, String> mapping = new LinkedHashMap<String, String>();

  static {
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0x201C}), "-");
    mapping.put(new String(new char[]{0xEF, 0xBF, 0xBD}), "'");
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0x153}), "\"");
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0x9D}), "\"");
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0x2122}), "'");
    mapping.put(new String(new char[]{0xC2, 0xA0}), " ");
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0x201D}), "-");
    mapping.put(new String(new char[]{0xC2, 0xAE}), "®");
    mapping.put(new String(new char[]{0xE2, 0x20AC, 0xA2}), "•");
  }

  private static String massage(String text) {
    for (final Map.Entry<String, String> entry : mapping.entrySet()) {
      text = text.replace(entry.getKey(), entry.getValue());
    }

    return text;
  }

  private static int identifier = Integer.MAX_VALUE;

  private static void processVideoElement(final Element videoElement, final Map<Movie, DVD> result) {
    final String title = videoElement.getAttribute("title");
    final String releaseDateString = videoElement.getAttribute("release_date");
    final String price = videoElement.getAttribute("retail_price");
    final String rating = videoElement.getAttribute("mpaa_rating");
    final String format = videoElement.getAttribute("format");
    final List<String> genres = split(videoElement.getAttribute("genre"));
    final List<String> cast = split(videoElement.getAttribute("cast"));
    final List<String> directors = split(videoElement.getAttribute("directors"));
    final String discs = videoElement.getAttribute("discs");
    final String poster = videoElement.getAttribute("image");
    final String synopsis = massage(videoElement.getAttribute("synopsis"));

    final Date releaseDate = DateUtilities.parseISO8601Date(releaseDateString);
    final String url = videoElement.getAttribute("url");
    final String length = videoElement.getAttribute("length");
    final String studio = videoElement.getAttribute("studio");

    int intLength;
    try {
      intLength = Integer.parseInt(length);
    } catch (final NumberFormatException ignored) {
      intLength = 0;
    }

    final DVD dvd = new DVD(title, price, format, discs, url);
    final Movie movie = new Movie(String.valueOf(identifier), title, rating, intLength, "", releaseDate, poster, synopsis, studio, directors, cast,
        genres);
    identifier--;

    result.put(movie, dvd);
  }

  private Map<Movie, DVD> processElement(final Node element) {
    final Map<Movie, DVD> result = new HashMap<Movie, DVD>();

    for (final Element child : children(element)) {
      if (shutdown) { return null; }
      processVideoElement(child, result);
    }

    return result;
  }

  private File getDetailsFile(final Movie movie, final Collection<Movie> movies) {
    if (movies == null || movies.contains(movie)) {
      return new File(getDetailsDirectory(), FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
    }

    return null;
  }

  private File getDetailsFile(final Movie movie) {
    return getDetailsFile(movie, getMoviesSet());
  }

  private void saveData(final Map<Movie, DVD> map) {
    for (final Map.Entry<Movie, DVD> entry : map.entrySet()) {
      if (shutdown) { return; }
      FileUtilities.writePersistable(entry.getValue(), getDetailsFile(entry.getKey(), null));
    }

    // do this last.  it signifies that we're done
    FileUtilities.writePersistableCollection(map.keySet(), getMoviesFile());
  }

  private List<Movie> updateBackgroundEntryPointWorker() {
    final File moviesFile = getMoviesFile();
    if (moviesFile.exists()) {
      if (FileUtilities.daysSinceNow(moviesFile) < 3) {
        return null;
      }
    }

    final Element element = NetworkUtilities.downloadXml(getServerAddress(), true);
    if (element == null) {
      return null;
    }

    if (shutdown) { return null; }
    final Map<Movie, DVD> map = processElement(element);
    if (CollectionUtilities.isEmpty(map)) {
      return null;
    }

    if (shutdown) { return null; }
    saveData(map);
    updatedMoviesClear();

    final Runnable runnable = new Runnable() {
      public void run() {
        reportResults(map);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
    return new ArrayList<Movie>(map.keySet());
  }


  private void updateBackgroundEntryPoint() {
    List<Movie> localMovies = updateBackgroundEntryPointWorker();
    if (shutdown) { return; }
    if (CollectionUtilities.isEmpty(localMovies)) {
      localMovies = loadMovies();
    }

    addPrimaryMovies(localMovies);
  }

  private void reportResults(final Map<Movie, DVD> map) {
    setMovies(new ArrayList<Movie>(map.keySet()));
    NowPlayingApplication.refresh();
  }

  private void updatePoster(final Movie movie) {
    model.getPosterCache().update(movie);
  }

  private void updateIMDb(final Movie movie) {
    model.getIMDbCache().update(movie);
  }

  /*
  private void updateAmazon(final Movie movie) {

  }

  private void updateWikipedia(final Movie movie) {

  }
   */

  @Override public void prioritizeMovie(final Movie movie) {
    if (!getMoviesSet().contains(movie)) {
      return;
    }

    super.prioritizeMovie(movie);
  }

  @Override protected void updateMovieDetails(final Movie movie) {
    if (shutdown) { return; }
    updatePoster(movie);
    if (shutdown) { return; }
    updateIMDb(movie);
    //updateWikipedia(movie);
    //updateAmazon(movie);
  }

  public DVD detailsForMovie(final Movie movie) {
    return FileUtilities.readPersistable(DVD.reader, getDetailsFile(movie));
  }
}