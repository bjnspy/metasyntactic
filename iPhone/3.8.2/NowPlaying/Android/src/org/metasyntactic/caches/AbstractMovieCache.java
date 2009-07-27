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

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;

public abstract class AbstractMovieCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(9);
  private final BoundedPrioritySet<Movie> primaryMovies = new BoundedPrioritySet<Movie>();
  private final BoundedPrioritySet<Movie> secondaryMovies = new BoundedPrioritySet<Movie>();

  private final Collection<Movie> updatedMovies = new HashSet<Movie>();

  protected AbstractMovieCache(final NowPlayingModel model) {
    super(model);


    final String name = getClass().getSimpleName() + "-UpdateMovieDetails";
    final Runnable runnable = new Runnable() {
      public void run() {
        try {
          updateMovieDetailsBackgroundEntryPoint();
        } catch (final InterruptedException e) {
          throw new RuntimeException(e);
        }
      }
    };

    ThreadingUtilities.performOnBackgroundThread(name, runnable, null, false);
  }

  private void updateMovieDetailsBackgroundEntryPoint() throws InterruptedException {
    while (!shutdown) {
      Movie movie = null;
      boolean isPriority = false;

      synchronized (lock) {
        final int count = prioritizedMovies.size();
        while (!shutdown && (movie = prioritizedMovies.removeAny()) == null && (movie = primaryMovies.removeAny()) == null && (movie = secondaryMovies
            .removeAny()) == null) {
          lock.wait();
        }
        isPriority = count != prioritizedMovies.size();
      }

      if (movie != null) {
        if (!updateMoviesContains(movie)) {
          updatedMoviesAdd(movie);
          updateMovieDetails(movie, isPriority);
        }
      }

      Thread.sleep(1000);
    }
  }

  protected void updateMovieDetails(final Movie movie, @SuppressWarnings("unused") final boolean priority) {
    updateMovieDetails(movie);
  }

  protected abstract void updateMovieDetails(Movie movie);

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

  public void prioritizeMovie(final Movie movie) {
    addMovie(movie, prioritizedMovies);
  }

  protected void addPrimaryMovie(final Movie movie) {
    addMovie(movie, primaryMovies);
  }

  protected void addPrimaryMovies(final List<Movie> movies) {
    addMovies(movies, primaryMovies);
  }

  protected void addSecondaryMovies(final List<Movie> movies) {
    addMovies(movies, secondaryMovies);
  }

  private void addMovie(final Movie movie, final BoundedPrioritySet<Movie> set) {
    synchronized (lock) {
      set.add(movie);
      lock.notifyAll();
    }
  }

  private void addMovies(final List<Movie> movies, final BoundedPrioritySet<Movie> set) {
    synchronized (lock) {
      set.addAll(movies);
      lock.notifyAll();
    }
  }
}
