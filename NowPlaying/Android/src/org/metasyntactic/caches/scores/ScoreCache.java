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

import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;

public class ScoreCache extends AbstractCache {
  private final ScoreProvider rottenTomatoesScoreProvider;
  private final ScoreProvider metacriticScoreProvider;
  private final ScoreProvider googleScoreProvider;
  private final ScoreProvider noneScoreProvider;
  private boolean updated;

  public ScoreCache(final NowPlayingModel model) {
    super(model);
    rottenTomatoesScoreProvider = new RottenTomatoesScoreProvider(model);
    metacriticScoreProvider = new MetacriticScoreProvider(model);
    googleScoreProvider = new GoogleScoreProvider(model);
    noneScoreProvider = new NoneScoreProvider(model);
  }

  private ScoreProvider[] getProviders() {
    return new ScoreProvider[]{rottenTomatoesScoreProvider, metacriticScoreProvider, googleScoreProvider, noneScoreProvider};
  }

  @Override
  public void shutdown() {
    super.shutdown();
    for (final ScoreProvider provider : getProviders()) {
      provider.shutdown();
    }
  }

  private ScoreProvider getScoreProvider(final Object type) {
    if (type.equals(ScoreType.Google)) {
      return googleScoreProvider;
    } else if (type.equals(ScoreType.Metacritic)) {
      return metacriticScoreProvider;
    } else if (type.equals(ScoreType.RottenTomatoes)) {
      return rottenTomatoesScoreProvider;
    } else if (type.equals(ScoreType.None)) {
      return noneScoreProvider;
    } else {
      throw new RuntimeException();
    }
  }

  private ScoreProvider getCurrentScoreProvider() {
    return getScoreProvider(model.getScoreType());
  }

  public Score getScore(final List<Movie> movies, final Movie movie) {
    return getCurrentScoreProvider().getScore(movies, movie);
  }

  public void update() {
    if (isNullOrEmpty(model.getUserAddress())) {
      return;
    }

    if (updated) {
      return;
    }
    updated = true;

    final ScoreType scoreType = model.getScoreType();
    final Runnable runnable = new Runnable() {
      public void run() {
        if (shutdown) { return; }
        final ScoreProvider primaryScoreProvider = getScoreProvider(scoreType);
        primaryScoreProvider.update();

        for (final ScoreProvider provider : getProviders()) {
          if (shutdown) { return; }
          if (provider != primaryScoreProvider) {
            provider.update();
          }
        }
      }
    };

    ThreadingUtilities.performOnBackgroundThread("Update score providers", runnable, null, false);
  }

  public List<Review> getReviews(final List<Movie> movies, final Movie movie) {
    ScoreProvider provider = getScoreProvider(model.getScoreType());
    if (provider == rottenTomatoesScoreProvider) {
      provider = metacriticScoreProvider;
    }
    return provider.getReviews(movies, movie);
  }

  public void prioritizeMovie(final List<Movie> movies, final Movie movie) {
    ScoreProvider provider = getScoreProvider(model.getScoreType());
    if (provider == rottenTomatoesScoreProvider) {
      provider = metacriticScoreProvider;
    }
    provider.prioritizeMovie(movies, movie);
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

  @Override
  public void onLowMemory() {
    super.onLowMemory();
    for (final ScoreProvider provider : getProviders()) {
      provider.onLowMemory();
    }
  }
}