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
package org.metasyntactic.caches;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;

public class IMDbCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> normalMovies = new BoundedPrioritySet<Movie>();
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>();

  public IMDbCache(final NowPlayingModel model) {
    super(model);

    final Runnable runnable = new Runnable() {
      public void run() {
        try {
          updateBackgroundEntryPoint();
        } catch (final InterruptedException e) {
          throw new RuntimeException(e);
        }
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update IMDb", runnable, null, false);
  }

  private static String movieFileName(final Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }

  private static File movieFilePath(final Movie movie) {
    return new File(NowPlayingApplication.imdbDirectory, movieFileName(movie));
  }

  public void update(final List<Movie> movies) {
    synchronized (lock) {
      normalMovies.addAll(movies);
      lock.notify();
    }
  }

  private void updateBackgroundEntryPoint() throws InterruptedException {
    while (!shutdown) {
      Movie movie = null;
      synchronized (lock) {
        while (!shutdown &&
            (movie = prioritizedMovies.removeAny()) == null &&
            (movie = normalMovies.removeAny()) == null) {
          lock.wait();
        }
      }

      downloadIMDbAddress(movie);
      Thread.sleep(1000);
    }
  }

  private static void downloadIMDbAddress(final Movie movie) {
    if (movie == null) {
      return;
    }

    // Nothing to do if we already have a valid imdb address
    if (!StringUtilities.isNullOrEmpty(movie.getIMDbAddress())) {
      return;
    }

    final File path = movieFilePath(movie);
    if (path.exists()) {
      final String address = FileUtilities.readString(path);
      if (address.length() > 0) {
        return;
      }

      if (FileUtilities.daysSinceNow(path) < 3) {
        return;
      }
    }

    final String url = "http://" + NowPlayingApplication.host + ".appspot.com/LookupIMDbListings?q="
    + StringUtilities.urlEncode(movie.getCanonicalTitle());

    final String imdbAddress = NetworkUtilities.downloadString(url, false);
    if (imdbAddress == null) {
      return;
    }

    FileUtilities.writeString(imdbAddress, path);
    NowPlayingApplication.refresh();
  }

  public static String getIMDbAddress(final Movie movie) {
    return FileUtilities.readString(movieFilePath(movie));
  }

  @Override protected List<File> getCacheDirectories() {
    return Collections.singletonList(NowPlayingApplication.imdbDirectory);
  }
}