package org.metasyntactic.caches.scores;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ScoreCache {
  private final Object lock = new Object();

  private final ScoreProvider rottenTomatoesScoreProvider = new RottenTomatoesScoreProvider(this);
  private final ScoreProvider metacriticScoreProvider = new MetacriticScoreProvider(this);
  private final ScoreProvider googleScoreProvider = new GoogleScoreProvider(this);

  private final NowPlayingModel model;

  public ScoreCache(NowPlayingModel model) {
    this.model = model;
  }


  public Map<String, Score> getScores() {
    switch (model.getRatingsProvider()) {
      case Google: return googleScoreProvider.getScores();
      case Metacritic: return metacriticScoreProvider.getScores();
      case RottenTomatoes: return rottenTomatoesScoreProvider.getScores();
      default: throw new RuntimeException();
    }
  }

  public void update() {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, true/*visible*/);
  }

  private void updateBackgroundEntryPoint() {
    switch (model.getRatingsProvider()) {
      case Google: googleScoreProvider.update(); break;
      case Metacritic: metacriticScoreProvider.update(); break;
      case RottenTomatoes: rottenTomatoesScoreProvider.update(); break;
    }
  }


  NowPlayingModel getModel() {
    return model;
  }
}