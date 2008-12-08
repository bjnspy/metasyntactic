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
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;

import java.util.List;

public class ScoreCache {
  private final ScoreProvider rottenTomatoesScoreProvider;
  private final ScoreProvider metacriticScoreProvider;
  private final ScoreProvider googleScoreProvider;
  private final ScoreProvider noneScoreProvider;

  private final NowPlayingModel model;

  public ScoreCache(final NowPlayingModel model) {
    this.model = model;
    rottenTomatoesScoreProvider = new RottenTomatoesScoreProvider(model);
    metacriticScoreProvider = new MetacriticScoreProvider(model);
    googleScoreProvider = new GoogleScoreProvider(model);
    noneScoreProvider = new NoneScoreProvider(model);
  }

  public void shutdown() {
    this.rottenTomatoesScoreProvider.shutdown();
    this.metacriticScoreProvider.shutdown();
    this.googleScoreProvider.shutdown();
    this.rottenTomatoesScoreProvider.shutdown();
  }

  public void createDirectories() {
    this.rottenTomatoesScoreProvider.createDirectory();
    this.metacriticScoreProvider.createDirectory();
    this.googleScoreProvider.createDirectory();
    this.noneScoreProvider.createDirectory();
  }

  private ScoreProvider getCurrentScoreProvider() {
    if (this.model.getScoreType() == ScoreType.Google) {
      return this.googleScoreProvider;
    } else if (this.model.getScoreType() == ScoreType.Metacritic) {
      return this.metacriticScoreProvider;
    } else if (this.model.getScoreType() == ScoreType.RottenTomatoes) {
      return this.rottenTomatoesScoreProvider;
    } else if (this.model.getScoreType() == ScoreType.None) {
      return this.noneScoreProvider;
    } else {
      throw new RuntimeException();
    }
  }

  public Score getScore(final List<Movie> movies, final Movie movie) {
    return getCurrentScoreProvider().getScore(movies, movie);
  }

  public void update() {
    getCurrentScoreProvider().update();
  }

  public List<Review> getReviews(final List<Movie> movies, final Movie movie) {
    return getCurrentScoreProvider().getReviews(movies, movie);
  }

  public void prioritizeMovie(final List<Movie> movies, final Movie movie) {
    getCurrentScoreProvider().prioritizeMovie(movies, movie);
  }

  public void clearStaleData() {
    rottenTomatoesScoreProvider.clearStaleData();
    metacriticScoreProvider.clearStaleData();
    googleScoreProvider.clearStaleData();
    noneScoreProvider.clearStaleData();
  }
}