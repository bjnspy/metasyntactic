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

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class PosterCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(9);

  public PosterCache(final NowPlayingModel model) {
    super(model);
  }

  private File posterFile(final Movie movie) {
    return new File(Application.postersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle() + ".jpg"));
  }

  public void update(final List<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Posters", runnable, this.lock, false);
  }

  private void updateBackgroundEntryPoint(final List<Movie> movies) {
    downloadPosters(movies);
  }

  private void downloadPosters(final List<Movie> movies) {
    final Set<Movie> moviesSet = new TreeSet<Movie>(movies);

    Movie movie;
    do {
      movie = this.prioritizedMovies.removeAny(moviesSet);
      downloadPoster(movie);
    } while (movie != null && !this.shutdown);
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
      Application.refresh();
    }
  }

  private byte[] downloadPosterWorker(final Movie movie) {
    byte[] data = NetworkUtilities.download(movie.getPoster(), false);
    if (data != null) {
      return data;
    }

    data = ApplePosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    data = downloadPosterFromFandango(movie);
    if (data != null) {
      return data;
    }

    /*
    data = ImdbPosterDownloader.download(movie);
    if (data != null) {
      return data;
    }
    */

    this.model.getLargePosterCache().downloadFirstPoster(movie);

    return null;
  }

  private byte[] downloadPosterFromFandango(final Movie movie) {
    final Location location = this.model.getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        this.model.getUserAddress());

    final String country = location == null ? "" : location.getCountry();
    String postalCode = location == null ? "10009" : location.getPostalCode();

    if (isNullOrEmpty(postalCode) || !"US".equals(country)) {
      postalCode = "10009";
    }

    return FandangoPosterDownloader.download(movie, postalCode);
  }

  protected List<File> getCacheDirectories() {
    return Collections.singletonList(Application.postersDirectory);
  }

  public byte[] getPoster(final Movie movie) {
    return FileUtilities.readBytes(posterFile(movie));
  }

  public File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return posterFile(movie);
  }

  public void prioritizeMovie(final Movie movie) {
    if (posterFile(movie).exists()) {
      return;
    }

    this.prioritizedMovies.add(movie);
  }
}
