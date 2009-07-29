// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package org.metasyntactic.caches;

import java.util.Collection;
import java.util.HashSet;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;

public abstract class AbstractMovieCache extends AbstractCache {
  private final Collection<Movie> updatedMovies = new HashSet<Movie>();

  protected AbstractMovieCache(final NowPlayingModel model) {
    super(model);
  }

  public final void updateMovieDetails(Movie movie) {
    if (!updateMoviesContains(movie)) {
      updatedMoviesAdd(movie);
      updateMovieDetailsWorker(movie);
    }
  }
  
  protected abstract void updateMovieDetailsWorker(Movie movie);

  @Override public void onLowMemory() {
    super.onLowMemory();
    updatedMoviesClear();
  }

  protected void updatedMoviesClear() {
    synchronized (lock) {
      updatedMovies.clear();
    }
  }

  private boolean updateMoviesContains(final Movie movie) {
    synchronized (lock) {
      return updatedMovies.contains(movie);
    }
  }

  private void updatedMoviesAdd(final Movie movie) {
    synchronized (lock) {
      updatedMovies.add(movie);
    }
  }
}
