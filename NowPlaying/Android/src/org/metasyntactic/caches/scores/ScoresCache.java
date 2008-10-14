package org.metasyntactic.caches.scores;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ScoresCache {
  private final Object lock = new Object();

  private final ScoresProvider rottenTomatoesScoresProvider = new RottenTomatoesScoresProvider(this);
  private final ScoresProvider metacriticScoresProvider = new MetacriticScoresProvider(this);
  private final ScoresProvider googleScoresProvider = new GoogleScoresProvider(this);

  private final NowPlayingModel model;

  public ScoresCache(NowPlayingModel model) {
    this.model = model;
  }


  public Map<String, Score> getScores() {
    switch (model.getRatingsProvider()) {
      case Google: return googleScoresProvider.getScores();
      case Metacritic: return metacriticScoresProvider.getScores();
      case RottenTomatoes: return rottenTomatoesScoresProvider.getScores();
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
      case Google: googleScoresProvider.update(); break;
      case Metacritic: metacriticScoresProvider.update(); break;
      case RottenTomatoes: rottenTomatoesScoresProvider.update(); break;
    }
  }


  NowPlayingModel getModel() {
    return model;
  }
}