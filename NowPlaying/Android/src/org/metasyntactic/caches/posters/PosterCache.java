package org.metasyntactic.caches.posters;

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;

import java.io.File;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PosterCache {
  private final Object lock = new Object();
  private final NowPlayingModel model;

  public PosterCache(NowPlayingModel model) {
    this.model = model;
  }


  private File posterFile(Movie movie) {
    return new File(Application.postersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  public void update(final List<Movie> movies) {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, false);
  }


  private void updateBackgroundEntryPoint(List<Movie> movies) {
    deleteObsoletePosters(movies);
    downloadPosters(movies);
  }


  private void downloadPosters(List<Movie> movies) {

  }


  private void deleteObsoletePosters(List<Movie> movies) {

  }
}
