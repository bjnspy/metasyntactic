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
      case Google:
        return googleScoreProvider.getScores();
      case Metacritic:
        return metacriticScoreProvider.getScores();
      case RottenTomatoes:
        return rottenTomatoesScoreProvider.getScores();
      default:
        throw new RuntimeException();
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
      case Google:
        googleScoreProvider.update();
        break;
      case Metacritic:
        metacriticScoreProvider.update();
        break;
      case RottenTomatoes:
        rottenTomatoesScoreProvider.update();
        break;
    }
  }


  NowPlayingModel getModel() {
    return model;
  }
}