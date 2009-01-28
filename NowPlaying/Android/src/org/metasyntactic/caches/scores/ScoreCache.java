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
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;

import android.sax.RootElement;

import java.io.File;
import java.util.Collections;
import java.util.List;

public class ScoreCache extends AbstractCache {
  private final ScoreProvider rottenTomatoesScoreProvider;
  private final ScoreProvider metacriticScoreProvider;
  private final ScoreProvider googleScoreProvider;
  private final ScoreProvider noneScoreProvider;

  public ScoreCache(final NowPlayingModel model) {
    super(model);
    this.rottenTomatoesScoreProvider = new RottenTomatoesScoreProvider(model);
    this.metacriticScoreProvider = new MetacriticScoreProvider(model);
    this.googleScoreProvider = new GoogleScoreProvider(model);
    this.noneScoreProvider = new NoneScoreProvider(model);
  }

  private ScoreProvider[] getProviders() {
    return new ScoreProvider[] {
        this.rottenTomatoesScoreProvider,
        this.metacriticScoreProvider,
        this.googleScoreProvider,
        this.noneScoreProvider
    };
  }

  public void shutdown() {
    for (final ScoreProvider provider : getProviders()) {
      provider.shutdown();
    }
  }

  public void createDirectories() {
    for (final ScoreProvider provider : getProviders()) {
      provider.createDirectory();
    }
  }

  private ScoreProvider getCurrentScoreProvider() {
    if (this.model.getScoreType().equals(ScoreType.Google)) {
      return this.googleScoreProvider;
    } else if (this.model.getScoreType().equals(ScoreType.Metacritic)) {
      return this.metacriticScoreProvider;
    } else if (this.model.getScoreType().equals(ScoreType.RottenTomatoes)) {
      return this.rottenTomatoesScoreProvider;
    } else if (this.model.getScoreType().equals(ScoreType.None)) {
      return this.noneScoreProvider;
    } else {
      throw new RuntimeException();
    }
  }

  public Score getScore(final List<Movie> movies, final Movie movie) {
    return getCurrentScoreProvider().getScore(movies, movie);
  }

  public void update() {
    final Runnable runnable = new Runnable() {
      public void run() {
        for (final ScoreProvider provider : getProviders()) {
          provider.update();
        }
      }
    };

    ThreadingUtilities.performOnBackgroundThread("Update score providers", runnable, this.lock, true);
  }

  public List<Review> getReviews(final List<Movie> movies, final Movie movie) {
    if (this.model.getScoreType().equals(ScoreType.Google)) {
      return this.googleScoreProvider.getReviews(movies, movie);
    } else if (this.model.getScoreType().equals(ScoreType.Metacritic)) {
      return this.metacriticScoreProvider.getReviews(movies, movie);
    } else if (this.model.getScoreType().equals(ScoreType.RottenTomatoes)) {
      return this.metacriticScoreProvider.getReviews(movies, movie);
    } else if (this.model.getScoreType().equals(ScoreType.None)) {
      return this.noneScoreProvider.getReviews(movies, movie);
    } else {
      throw new RuntimeException();
    }
  }

  public void prioritizeMovie(final List<Movie> movies, final Movie movie) {
    for (final ScoreProvider provider : getProviders()) {
      provider.prioritizeMovie(movies, movie);
    }
  }

  public void clearStaleData() {
    for (final ScoreProvider provider : getProviders()) {
      provider.clearStaleData();
    }
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.emptyList();
  }
}