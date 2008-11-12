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
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.io.File;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class PosterCache {
  private final Object lock = new Object();
  private final NowPlayingModel model;
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(8);

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
    ThreadingUtilities.performOnBackgroundThread("Update Posters", runnable, lock, false);
  }

  private void updateBackgroundEntryPoint(List<Movie> movies) {
    deleteObsoletePosters(movies);
    downloadPosters(movies);
  }

  private void downloadPosters(List<Movie> movies) {
    Set<Movie> moviesSet = new TreeSet<Movie>(movies);

    Movie movie;
    do {
      movie = prioritizedMovies.removeAny(moviesSet);
      downloadPoster(movie);
    } while (movie != null);
  }

  private void downloadPoster(Movie movie) {
    if (movie == null) {
      return;
    }

    if (posterFile(movie).exists()) {
      return;
    }

    byte[] data = downloadPosterWorker(movie);
    if (data != null) {
      FileUtilities.writeBytes(data, posterFile(movie));
      Application.refresh();
    }
  }

  private byte[] downloadPosterWorker(Movie movie) {
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

    data = ImdbPosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    return null;
  }

  private byte[] downloadPosterFromFandango(Movie movie) {
    Location location = model.getUserLocationCache()
        .downloadUserAddressLocationBackgroundEntryPoint(model.getUserLocation());

    String country = location == null ? "" : location.getCountry();
    String postalCode = location == null ? "10009" : location.getPostalCode();

    if (StringUtilities.isNullOrEmpty(postalCode) || !"US".equals(country)) {
      postalCode = "10009";
    }

    return FandangoPosterDownloader.download(movie, postalCode);
  }

  private void deleteObsoletePosters(List<Movie> movies) {

  }

  public byte[] getPoster(Movie movie) {
    return FileUtilities.readBytes(posterFile(movie));
  }

  public void prioritizeMovie(Movie movie) {
    if (posterFile(movie).exists()) {
      return;
    }

    prioritizedMovies.add(movie);
  }
}
