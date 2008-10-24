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

import android.util.Log;

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.Pulser;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public abstract class AbstractScoreProvider implements ScoreProvider {
  private final ScoreCache parentCache;

  private Map<String, Score> scores = Collections.emptyMap();
  private String hash = "";


  private final Object movieMapLock = new Object();
  private List<Movie> movies = Collections.emptyList();
  private Map<String, String> movieMap = Collections.emptyMap();


  public AbstractScoreProvider(ScoreCache parentCache) {
    this.parentCache = parentCache;
  }


  protected abstract String getProviderName();


  protected NowPlayingModel getModel() {
    return parentCache.getModel();
  }


  private File ratingsFile() {
    return new File(Application.ratingsDirectory, getProviderName());
  }


  private File hashFile() {
    return new File(Application.ratingsDirectory, getProviderName() + "-Hash");
  }


  private Map<String, Score> loadScores() {
    Map<String, Score> result =
        FileUtilities.readStringToPersistableMap(Score.reader, ratingsFile());
    if (result == null) {
      result = Collections.emptyMap();
    }
    return result;
  }


  private String loadHash() {
    String string = FileUtilities.readString(hashFile());
    if (string == null) {
      return "";
    }
    return string;
  }


  public Map<String, Score> getScores() {
    if (scores == null) {
      scores = loadScores();
    }
    return scores;
  }


  private String getHash() {
    if (hash == null) {
      hash = loadHash();
    }
    return hash;
  }


  public void update() {
    if (FileUtilities.tooSoon(hashFile())) {
      return;
    }

    updateWorker();
  }


  public void updateWorker() {
    String localHash = getHash();
    final String serverHash = lookupServerHash();

    if (StringUtilities.isNullOrEmpty(serverHash)) {
      return;
    }

    if ("0".equals(serverHash)) {
      return;
    }

    if (localHash.equals(serverHash)) {
      return;
    }

    final Map<String, Score> result = lookupServerRatings();

    if (CollectionUtilities.isEmpty(result)) {
      return;
    }

    reportResult(serverHash, result);
    saveResult(serverHash, result);
  }


  private void saveResult(String serverHash, Map<String, Score> result) {
    FileUtilities.writeStringToPersistableMap(result, ratingsFile());

    // write this file last, to indicate that we are done.
    FileUtilities.writeString(serverHash, hashFile());
  }


  private void reportResult(final String hash, final Map<String, Score> scores) {
    Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(hash, scores);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportResultOnMainThread(String hash, Map<String, Score> scores) {
    this.hash = hash;
    this.scores = scores;
    movieMap = Collections.emptyMap();
  }


  public Score getScore(final List<Movie> movies, Movie movie) {
    if (movieMap.isEmpty() || movies != this.movies) {
      this.movies = movies;
      final Map<String, Score> scores = getScores();
     
      Runnable runnable = new Runnable() {
        public void run() {
          regenerateMovieMap(movies, scores);
          
          
        }
      };
      ThreadingUtilities.performOnBackgroundThread("Regenerate Movie Map", runnable, movieMapLock, false);
    }

    return scores.get(movieMap.get(movie.getCanonicalTitle()));
  }


  private void regenerateMovieMap(List<Movie> movies, Map<String, Score> scores) {
    final Map<String, String> result = new HashMap<String, String>();

    List<String> titles = new ArrayList<String>(scores.keySet());
    List<String> lowercaseTitles = new ArrayList<String>();
    for (String title : titles) {
      lowercaseTitles.add(title.toLowerCase());
    }

    for (Movie movie : movies) {
      String lowercaseTitle = movie.getCanonicalTitle().toLowerCase();
      int index = EditDistance.findClosestMatchIndex(lowercaseTitle, lowercaseTitles);

      if (index >= 0) {
        String title = titles.get(index);
        result.put(movie.getCanonicalTitle(), title);
      }
    }

    if (result.isEmpty()) {
      return;
    }

    //FileUtilities.writeObject(result, movieMapFile());

    Runnable runnable = new Runnable() {
      public void run() {
        reportMovieMap(result);
      }
    };

    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportMovieMap(Map<String, String> result) {
    movieMap = result;
    Application.refresh();
  }


  protected abstract String lookupServerHash();


  protected abstract Map<String, Score> lookupServerRatings();
}
