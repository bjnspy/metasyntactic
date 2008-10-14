package org.metasyntactic.caches.scores;

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.io.File;
import java.util.Collections;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public abstract class AbstractScoreProvider implements ScoreProvider {
  private final ScoreCache parentCache;

  private Map<String, Score> scores;
  private String hash;


  public AbstractScoreProvider(ScoreCache parentCache) {
    this.parentCache = parentCache;
  }


  protected abstract String getProviderName();

  protected NowPlayingModel getModel() {
    return parentCache.getModel();
  }

  private String ratingsFile() {
    return new File(Application.ratingsDirectory, getProviderName()).getAbsolutePath();
  }


  private String ratingsHashFile() {
    return ratingsFile() + "-Hash";
  }


  private Map<String, Score> loadScores() {
    Map<String, Score> result = FileUtilities.readObject(ratingsFile());
    if (result == null) {
      result = Collections.emptyMap();
    }
    return result;
  }


  private String loadHash() {
    String result = FileUtilities.readObject(ratingsHashFile());
    if (result == null) {
      result = "";
    }
    return result;
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
    if (FileUtilities.tooSoon(ratingsFile())) {
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

    FileUtilities.writeObject(result, ratingsFile());
    FileUtilities.writeObject(serverHash, ratingsHashFile());

    Runnable runnable = new Runnable() {
      public void run() {
        reportResultOnMainThread(serverHash, result);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportResultOnMainThread(String hash, Map<String, Score> scores) {
    this.hash = hash;
    this.scores = scores;
    getModel().onRatingsUpdated();
  }


  protected abstract String lookupServerHash();


  protected abstract Map<String, Score> lookupServerRatings();
}
