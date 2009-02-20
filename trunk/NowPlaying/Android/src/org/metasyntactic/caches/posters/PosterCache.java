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
package org.metasyntactic.caches.posters;

import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;

public class PosterCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(9);

  public PosterCache(final NowPlayingModel model) {
    super(model);
  }

  private static File posterFile(final Movie movie) {
    return new File(NowPlayingApplication.postersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle() + ".jpg"));
  }

  public void update(final List<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Posters", runnable, lock, false);
  }

  private void updateBackgroundEntryPoint(final List<Movie> movies) {
    downloadPosters(movies);
  }

  private void downloadPosters(final List<Movie> movies) {
    final Set<Movie> moviesSet = new TreeSet<Movie>(movies);

    Movie movie;
    do {
      movie = prioritizedMovies.removeAny(moviesSet);
      downloadPoster(movie);
    } while (movie != null && !shutdown);
  }

  private void downloadPoster(final Movie movie) {
    if (movie == null) {
      return;
    }

    if (posterFile(movie).exists()) {
      return;
    }

    final byte[] data = downloadPosterWorker(movie);
    if (data != null) {
      FileUtilities.writeBytes(data, posterFile(movie));
      NowPlayingApplication.refresh();
    }
  }

  private byte[] downloadPosterWorker(final Movie movie) {
    //if (shutdown) { return; }
    byte[] data = NetworkUtilities.download(movie.getPoster(), false);
    if (data != null) {
      return data;
    }

    //if (shutdown) { return; }
    data = ApplePosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    //if (shutdown) { return; }
    data = downloadPosterFromFandango(movie);
    if (data != null) {
      return data;
    }

    /*
     * data = ImdbPosterDownloader.download(movie); if (data != null) { return
     * data; }
     */

    //if (shutdown) { return; }
    model.getLargePosterCache().downloadFirstPoster(movie);

    return null;
  }

  private byte[] downloadPosterFromFandango(final Movie movie) {
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(model.getUserAddress());

    final String country = location == null ? "" : location.getCountry();
    String postalCode = location == null ? "10009" : location.getPostalCode();

    if (isNullOrEmpty(postalCode) || !"US".equals(country)) {
      postalCode = "10009";
    }

    return FandangoPosterDownloader.download(movie, postalCode);
  }

  @Override protected List<File> getCacheDirectories() {
    return Collections.singletonList(NowPlayingApplication.postersDirectory);
  }

  public static byte[] getPoster(final Movie movie) {
    return FileUtilities.readBytes(posterFile(movie));
  }

  public static File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return posterFile(movie);
  }

  public void prioritizeMovie(final Movie movie) {
    if (posterFile(movie).exists()) {
      return;
    }

    prioritizedMovies.add(movie);
  }

  @Override
  public void onLowMemory() {
    super.onLowMemory();
    ApplePosterDownloader.onLowMemory();
    FandangoPosterDownloader.onLowMemory();
    ImdbPosterDownloader.onLowMemory();
  }
}
