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

import org.metasyntactic.Constants;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TrailerCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(9);
  private final BoundedPrioritySet<Movie> moviesWithTrailers = new BoundedPrioritySet<Movie>();
  private final BoundedPrioritySet<Movie> moviesWithoutTrailers = new BoundedPrioritySet<Movie>();

  public TrailerCache(final NowPlayingModel model) {
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
    ThreadingUtilities.performOnBackgroundThread("Update Trailers", runnable, null, false);
  }

  private static String trailerFileName(final Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }

  private static File trailerFilePath(final Movie movie) {
    return new File(NowPlayingApplication.trailersDirectory, trailerFileName(movie));
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.singletonList(NowPlayingApplication.trailersDirectory);
  }

  public void update(final List<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        addMovies(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Trailers", runnable, lock, false/* visible */);
  }

  private void addMovies(final List<Movie> movies) {
    synchronized (lock) {
      final long now = new Date().getTime();

      for (final Movie movie : movies) {
        final File file = trailerFilePath(movie);
        if (file.exists()) {
          final long writeTime = file.lastModified();
          final long span = Math.abs(writeTime - now);

          if (span > 3 * Constants.ONE_DAY) {
            moviesWithTrailers.add(movie);
          }
        } else {
          moviesWithoutTrailers.add(movie);
        }

        lock.notify();
      }
    }
  }

  private static Map<String, List<String>> index;

  private static Map<String, List<String>> getIndex() {
    Map<String, List<String>> result = index;
    if (result == null) {
      final String url = "http://" + NowPlayingApplication.host + ".appspot.com/LookupTrailerListings?q=index";
      final String indexText = NetworkUtilities.downloadString(url, false);
      if (indexText == null) {
        return null;
      }

      result = index = generateIndex(indexText);
    }

    return result;
  }

  private void updateBackgroundEntryPoint() throws InterruptedException {
    while (!shutdown) {
      Movie movie = null;
      synchronized (lock) {
        while (!shutdown &&
          (movie = prioritizedMovies.removeAny()) == null &&
          (movie = moviesWithoutTrailers.removeAny()) == null &&
          (movie = moviesWithTrailers.removeAny()) == null) {
          lock.wait();
        }
      }

      downloadMovieTrailer(movie);
      Thread.sleep(1000);
    }
  }

  private static void downloadMovieTrailer(final Movie movie) {
    if (movie == null) {
      return;
    }

    final File trailerFile = trailerFilePath(movie);
    if (trailerFile.exists()) {
      return;
    }

    final Map<String, List<String>> index = getIndex();

    final String bestKey = EditDistance.findClosestMatch(movie.getCanonicalTitle().toLowerCase(), index.keySet());
    if (bestKey == null) {
      // no trailer for this movie. record that fact. we'll try again later
      FileUtilities.writeStringCollection(new ArrayList<String>(), trailerFilePath(movie));
      return;
    }

    final List<String> studioAndLocation = index.get(bestKey);
    final String studio = studioAndLocation.get(0);
    final String location = studioAndLocation.get(1);

    final String url = "http://" + NowPlayingApplication.host + ".appspot.com/LookupTrailerListings?studio=" + studio + "&name=" + location;
    final String trailersString = NetworkUtilities.downloadString(url, false);

    if (trailersString == null) {
      // didn't get any data. ignore this for now.
      return;
    }

    final List<String> trailers = Arrays.asList(trailersString.split("\n"));
    FileUtilities.writeString(trailers.get(0), trailerFile);
    NowPlayingApplication.refresh();
  }

  private static Map<String, List<String>> generateIndex(final String indexText) {
    final Map<String, List<String>> index = new HashMap<String, List<String>>();

    for (final String row : indexText.split("\n")) {
      final String[] values = row.split("\t");
      if (values.length != 3) {
        continue;
      }

      final String fullTitle = values[0];
      final String studio = values[1];
      final String location = values[2];

      index.put(fullTitle.toLowerCase(), Arrays.asList(studio, location));
    }

    return index;
  }

  public static String getTrailer(final Movie movie) {
    return FileUtilities.readString(trailerFilePath(movie));
  }

  public void prioritizeMovie(final Movie movie) {
    synchronized (lock) {
      prioritizedMovies.add(movie);
      lock.notify();
    }
  }

  @Override
  public void onLowMemory() {
    super.onLowMemory();
    index = null;
  }
}
