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

  @Override
  public void shutdown() {
    super.shutdown();
    for (final ScoreProvider provider : getProviders()) {
      provider.shutdown();
    }
  }

  public void createDirectories() {
    for (final ScoreProvider provider : getProviders()) {
      provider.createDirectory();
    }
  }

  private ScoreProvider getScoreProvider(final ScoreType type) {
    if (type.equals(ScoreType.Google)) {
      return this.googleScoreProvider;
    } else if (type.equals(ScoreType.Metacritic)) {
      return this.metacriticScoreProvider;
    } else if (type.equals(ScoreType.RottenTomatoes)) {
      return this.rottenTomatoesScoreProvider;
    } else if (type.equals(ScoreType.None)) {
      return this.noneScoreProvider;
    } else {
      throw new RuntimeException();
    }
  }

  private ScoreProvider getCurrentScoreProvider() {
    return getScoreProvider(this.model.getScoreType());
  }

  public Score getScore(final List<Movie> movies, final Movie movie) {
    return getCurrentScoreProvider().getScore(movies, movie);
  }

  public void update() {
    final ScoreType scoreType = this.model.getScoreType();
    final Runnable runnable = new Runnable() {
      public void run() {
        if (ScoreCache.this.shutdown) { return; }
        final ScoreProvider primaryScoreProvider = getScoreProvider(scoreType);
        primaryScoreProvider.update();

        for (final ScoreProvider provider : getProviders()) {
          if (ScoreCache.this.shutdown) { return; }
          if (provider != primaryScoreProvider) {
            provider.update();
          }
        }
      }
    };

    ThreadingUtilities.performOnBackgroundThread("Update score providers", runnable, this.lock, true);
  }

  public List<Review> getReviews(final List<Movie> movies, final Movie movie) {
    ScoreProvider provider = getScoreProvider(this.model.getScoreType());
    if (provider == this.rottenTomatoesScoreProvider) {
      provider = this.metacriticScoreProvider;
    }
    return provider.getReviews(movies, movie);
  }

  public void prioritizeMovie(final List<Movie> movies, final Movie movie) {
    for (final ScoreProvider provider : getProviders()) {
      provider.prioritizeMovie(movies, movie);
    }
  }

  @Override
  public void clearStaleData() {
    super.clearStaleData();
    for (final ScoreProvider provider : getProviders()) {
      provider.clearStaleData();
    }
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.emptyList();
  }
}