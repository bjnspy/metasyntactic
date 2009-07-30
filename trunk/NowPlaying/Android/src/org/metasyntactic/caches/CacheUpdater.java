package org.metasyntactic.caches;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LogUtilities;

public class CacheUpdater extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovieOperations = new BoundedPrioritySet<Movie>(9);
  private final BoundedPrioritySet<Movie> imageOperations = new BoundedPrioritySet<Movie>(9);
  private final BoundedPrioritySet<Movie> movieOperations = new BoundedPrioritySet<Movie>();
  
  public CacheUpdater(NowPlayingModel model) {
    super(model);
    
    spawnMovieUpdateThread();
    spawnImageUpdateThread();
  }

  private void spawnMovieUpdateThread() {
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
  
  private void spawnImageUpdateThread() {
    final String name = getClass().getSimpleName() + "-UpdateImages";
    final Runnable runnable = new Runnable() {
      public void run() {
        try {
          updateImagesBackgroundEntryPoint();
        } catch (final InterruptedException e) {
          throw new RuntimeException(e);
        }
      }
    };

    ThreadingUtilities.performOnBackgroundThread(name, runnable, null, false);
  }
  
  protected void updateMovieDetailsBackgroundEntryPoint() throws InterruptedException {
    while (!shutdown) {
      Movie movie = null;

      synchronized (lock) {
        while (!shutdown
            && (movie = prioritizedMovieOperations.removeAny()) == null
            && (movie = movieOperations.removeAny()) == null) {
           lock.wait();
        }
      }
      
      if (shutdown) {
        return;
      }

      if (movie != null) {
         updateMovieDetails(movie);
      }

      Thread.sleep(250);
    }
  }

  private void updateImagesBackgroundEntryPoint() throws InterruptedException {
    while (!shutdown) {
      Movie movie = null;

      synchronized (lock) {
        while (!shutdown
            && (movie = prioritizedMovieOperations.removeAny()) == null
            && (movie = movieOperations.removeAny()) == null) {
           lock.wait();
        }
      }
      
      if (shutdown) {
        return;
      }

      if (movie != null) {
        model.getPosterCache().updateMovieDetails(movie);
      }

      Thread.sleep(1000);
    }
  }

  private void updateMovieDetails(Movie movie) {
    LogUtilities.i(getClass().getSimpleName(), "update: " + movie.getCanonicalTitle());
 
    model.getPosterCache().updateMovieDetails(movie);
    if (shutdown) { return; }
    model.getUpcomingCache().updateMovieDetails(movie);
    if (shutdown) { return; }
    model.getTrailerCache().updateMovieDetails(movie);
    if (shutdown) { return; }
    model.getIMDbCache().updateMovieDetails(movie);
    if (shutdown) { return; }
    model.getAmazonCache().updateMovieDetails(movie);
    if (shutdown) { return; }
    model.getWikipediaCache().updateMovieDetails(movie);
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.emptyList();
  }
  
  public void prioritizeMovie(final Movie movie, boolean now) {
    LogUtilities.i(getClass().getSimpleName(), "prioritizeMovie:" + (now ? "now:" : "") + movie.getCanonicalTitle());
    if (now) {
      final String name = getClass().getSimpleName() + "-UpdateMovieDetails";
      Runnable runnable = new Runnable() {
        public void run() {
          updateMovieDetails(movie);
        }
      };
      ThreadingUtilities.performOnBackgroundThread(name, runnable, null, true);
    } else {
      addMovie(movie, prioritizedMovieOperations);
      addMovie(movie, imageOperations);
    }
  }

  public void addMovie(final Movie movie) {
    addMovie(movie, movieOperations);
  }

  public void addMovies(final List<Movie> movies) {
    addMovies(movies, movieOperations);
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
