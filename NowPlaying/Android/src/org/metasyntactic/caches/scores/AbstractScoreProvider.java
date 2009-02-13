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
package org.metasyntactic.caches.scores;

import org.metasyntactic.Application;
import org.metasyntactic.Constants;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.CollectionUtilities;
import static org.metasyntactic.utilities.CollectionUtilities.size;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.metasyntactic.utilities.difference.EditDistance;
import org.w3c.dom.Element;

import java.io.File;
import java.util.*;

public abstract class AbstractScoreProvider extends AbstractCache implements ScoreProvider {
  private static class MovieAndMap {
    private final Movie movie;
    private final Map<String, String> movieMap;

    private MovieAndMap(final Movie movie, final Map<String, String> movieMap) {
      this.movie = movie;
      this.movieMap = movieMap;
    }
  }

  private Map<String, Score> scores;
  private String hash;
  private final Object movieMapLock = new Object();
  private final BoundedPrioritySet<MovieAndMap> prioritizedMovies = new BoundedPrioritySet<MovieAndMap>(9);
  private List<Movie> movies;
  private Map<String, String> movieMap_doNotAccessDirectly;
  private final File providerDirectory = new File(Application.scoresDirectory, getProviderName());
  private final File reviewsDirectory = new File(Application.reviewsDirectory, getProviderName());

  protected AbstractScoreProvider(final NowPlayingModel model) {
    super(model);

    createDirectory();
  }

  public final void createDirectory() {
    this.providerDirectory.mkdirs();
    this.reviewsDirectory.mkdirs();
  }

  protected abstract String getProviderName();

  protected NowPlayingModel getModel() {
    return this.model;
  }

  private File scoresFile() {
    return new File(this.providerDirectory, "Scores");
  }

  private File hashFile() {
    return new File(this.providerDirectory, "Hash");
  }

  private File movieMapFile() {
    return new File(this.providerDirectory, "MovieMap");
  }

  private Map<String, Score> loadScores() {
    Map<String, Score> result = FileUtilities.readStringToPersistableMap(Score.reader, scoresFile());
    if (result == null) {
      result = Collections.emptyMap();
    }
    return result;
  }

  private String loadHash() {
    final String string = FileUtilities.readString(hashFile());
    if (string == null) {
      return "";
    }
    return string;
  }

  private Map<String, String> loadMovieMap() {
    final Map<String, String> result = FileUtilities.readStringToStringMap(movieMapFile());
    if (result == null) {
      return Collections.emptyMap();
    }
    return result;
  }

  public Map<String, Score> getScores() {
    if (this.scores == null) {
      this.scores = loadScores();
    }
    return Collections.unmodifiableMap(this.scores);
  }

  private String getHash() {
    if (this.hash == null) {
      this.hash = loadHash();
    }
    return this.hash;
  }

  private Map<String, String> getMovieMap() {
    if (this.movieMap_doNotAccessDirectly == null) {
      this.movieMap_doNotAccessDirectly = loadMovieMap();
    }
    return this.movieMap_doNotAccessDirectly;
  }

  public void update() {
    updateScores();
  }

  private void updateScores() {
    if (this.shutdown) {
      return;
    }
    final long start = System.currentTimeMillis();
    Map<String, Score> map = updateScoresWorker();
    LogUtilities.logTime(getClass(), "Update Scores", start);

    if (this.shutdown) {
      return;
    }
    if (map == null) {
      map = loadScores();
    }
    if (this.shutdown) {
      return;
    }
    updateReviewsWorker(map);
  }

  private Map<String, Score> updateScoresWorker() {
    final File hashFile = hashFile();
    if (hashFile.exists()) {
      if (Math.abs(hashFile.lastModified() - new Date().getTime()) < Constants.ONE_DAY) {
        return null;
      }
    }

    final String localHash = getHash();
    final String serverHash = lookupServerHash();

    if (isNullOrEmpty(serverHash)) {
      return null;
    }

    if ("0".equals(serverHash)) {
      return null;
    }

    if (localHash.equals(serverHash)) {
      return null;
    }

    final Map<String, Score> result = lookupServerScores();

    if (CollectionUtilities.isEmpty(result)) {
      return null;
    }

    saveResult(serverHash, result);
    reportResult(serverHash, result);

    return result;
  }

  private void saveResult(final String serverHash, final Map<String, Score> result) {
    FileUtilities.writeStringToPersistableMap(result, scoresFile());

    // write this file last, to indicate that we are done.
    FileUtilities.writeString(serverHash, hashFile());
  }

  private void reportResult(final String hash, final Map<String, Score> scores) {
    final Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(hash, scores);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportResultOnMainThread(final String hash, final Map<String, Score> scores) {
    this.hash = hash;
    this.scores = scores;
    this.movieMap_doNotAccessDirectly = null;
    this.movies = null;

    Application.refresh(true);
  }

  public Score getScore(final List<Movie> movies, final Movie movie) {
    ensureMovieMap(movies);

    return getScores().get(getMovieMap().get(movie.getCanonicalTitle()));
  }

  private void ensureMovieMap(final List<Movie> movies) {
    if (movies != this.movies) {
      this.movies = movies;
      final Map<String, Score> localScores = getScores();

      final Runnable runnable = new Runnable() {
        public void run() {
          regenerateMovieMap(movies, localScores);
        }
      };
      ThreadingUtilities.performOnBackgroundThread("Regenerate Movie Map", runnable, this.movieMapLock, true);
    }
  }

  private void regenerateMovieMap(final List<Movie> movies, final Map<String, Score> scores) {
    final Map<String, String> result = new HashMap<String, String>();

    final List<String> titles = new ArrayList<String>(scores.keySet());
    final List<String> lowercaseTitles = new ArrayList<String>();
    for (final String title : titles) {
      lowercaseTitles.add(title.toLowerCase());
    }

    for (final Movie movie : movies) {
      final String lowercaseTitle = movie.getCanonicalTitle().toLowerCase();
      final int index = EditDistance.findClosestMatchIndex(lowercaseTitle, lowercaseTitles);

      if (index >= 0) {
        final String title = titles.get(index);
        result.put(movie.getCanonicalTitle(), title);
      }
    }

    if (result.isEmpty()) {
      return;
    }

    FileUtilities.writeStringToStringMap(result, movieMapFile());

    final Runnable runnable = new Runnable() {
      public void run() {
        reportMovieMap(result, movies);
      }
    };

    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportMovieMap(final Map<String, String> result, final List<Movie> movies) {
    this.movieMap_doNotAccessDirectly = result;
    this.movies = movies;
    Application.refresh(true);
  }

  protected abstract String lookupServerHash();

  protected abstract Map<String, Score> lookupServerScores();

  private File reviewsFile(final String title) {
    return new File(this.reviewsDirectory, FileUtilities.sanitizeFileName(title));
  }

  private File reviewsHashFile(final String title) {
    return new File(this.reviewsDirectory, FileUtilities.sanitizeFileName(title) + "-Hash");
  }

  private void updateReviewsWorker(final Map<String, Score> scoresMap) {
    final Set<Score> scoresWithoutReviews = new TreeSet<Score>();
    final Set<Score> scoresWithReviews = new TreeSet<Score>();

    for (final Map.Entry<String, Score> entry : scoresMap.entrySet()) {
      final File file = reviewsFile(entry.getKey());
      if (file.exists()) {
        if (FileUtilities.daysSinceNow(file) > 2 * Constants.ONE_DAY) {
          scoresWithReviews.add(entry.getValue());
        }
      } else {
        scoresWithoutReviews.add(entry.getValue());
      }
    }

    downloadReviews(scoresWithoutReviews, scoresMap);
    downloadReviews(scoresWithReviews, scoresMap);
  }

  private void downloadReviews(final Set<Score> scores, final Map<String, Score> scoresMap) {
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(
        getModel().getUserAddress());

    if (location == null) {
      return;
    }

    Score score;
    do {
      score = getNextScore(scores, scoresMap);
      downloadReviews(score, location);
    } while (score != null && !this.shutdown);
  }

  private Score getNextScore(final Set<Score> scores, final Map<String, Score> scoresMap) {
    final MovieAndMap movieAndMap = this.prioritizedMovies.removeAny();
    if (movieAndMap != null) {
      final Movie movie = movieAndMap.movie;
      final Map<String, String> movieMap = movieAndMap.movieMap;
      final Score score = scoresMap.get(movieMap.get(movie.getCanonicalTitle()));
      if (score != null && !reviewsFile(score.getCanonicalTitle()).exists()) {
        return score;
      }
    }

    if (!scores.isEmpty()) {
      final Iterator<Score> iterator = scores.iterator();
      final Score score = iterator.next();
      iterator.remove();

      return score;
    }

    return null;
  }

  public void prioritizeMovie(final List<Movie> movies, final Movie movie) {
    ensureMovieMap(movies);
    this.prioritizedMovies.add(new MovieAndMap(movie, getMovieMap()));
  }

  private static String serverReviewsAddress(final Location location, final Score score) {
    String country = Locale.getDefault().getCountry();
    if (!isNullOrEmpty(location.getCountry())) {
      country = location.getCountry();
    }

    return "http://" + Application.host + ".appspot.com/LookupMovieReviews2?country=" + country + "&language=" + Locale.getDefault().getLanguage() + "&id=" + score.getIdentifier() + "&provider=" + score.getProvider() + "&latitude=" + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location.getLongitude() * 1000000);
  }

  private void downloadReviews(final Score score, final Location location) {
    if (score != null) {
      final String address = serverReviewsAddress(location, score) + "&hash=true";
      String serverHash = NetworkUtilities.downloadString(address, false);

      if (serverHash == null) {
        serverHash = "0";
      }

      final String localHash = FileUtilities.readString(reviewsHashFile(score.getCanonicalTitle()));
      if (serverHash.equals(localHash)) {
        return;
      }

      final List<Review> reviews = downloadReviewContents(location, score);
      if (reviews == null) {
        // didn't download.  just ignore it.
        return;
      }

      if (reviews.isEmpty()) {
        // we got no reviews.  only save that fact if we don't currently have
        // any reviews.  This way we don't end up checking every single time
        // for movies that don't have reviews yet
        final List<Review> existingReviews = FileUtilities.readPersistableList(Review.reader,
                                                                               reviewsFile(score.getCanonicalTitle()));
        if (size(existingReviews) > 0) {
          // we have reviews already.  don't wipe it out.
          return;
        }
      }

      save(score.getCanonicalTitle(), reviews, serverHash);
      Application.refresh();
    }
  }

  private static List<Review> downloadReviewContents(final Location location, final Score score) {
    final String address = serverReviewsAddress(location, score);
    final Element element = NetworkUtilities.downloadXml(address, false);
    if (element == null) {
      return null;
    }

    return extractReviews(element);
  }

  private static List<Review> extractReviews(final Element element) {
    final List<Review> result = new ArrayList<Review>();
    for (final Element reviewElement : children(element)) {
      final String text = reviewElement.getAttribute("text");
      final String score = reviewElement.getAttribute("score");
      final String link = reviewElement.getAttribute("link");
      final String author = reviewElement.getAttribute("author");
      final String source = reviewElement.getAttribute("source");

      if (author.contains("HREF")) {
        continue;
      }

      int scoreValue = -1;
      try {
        scoreValue = Integer.parseInt(score);
      } catch (final NumberFormatException ignored) {
      }

      result.add(new Review(text, scoreValue, link, author, source));
    }

    return result;
  }

  private void save(final String title, final List<Review> reviews, final String serverHash) {
    FileUtilities.writePersistableCollection(reviews, reviewsFile(title));

    // do this last.  it marks us being complete.
    FileUtilities.writeString(serverHash, reviewsHashFile(title));
  }

  public List<Review> getReviews(final List<Movie> movies, final Movie movie) {
    ensureMovieMap(movies);
    final String title = getMovieMap().get(movie.getCanonicalTitle());
    if (isNullOrEmpty(title)) {
      return Collections.emptyList();
    }

    return FileUtilities.readPersistableList(Review.reader, reviewsFile(title));
  }

  @Override protected List<File> getCacheDirectories() {
    return Collections.singletonList(this.reviewsDirectory);
  }
}
