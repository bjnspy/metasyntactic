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

import org.metasyntactic.Application;
import org.metasyntactic.Constants;
import org.metasyntactic.collections.BoundedPrioritySet;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.*;

public class TrailerCache extends AbstractCache {
  private final BoundedPrioritySet<Movie> prioritizedMovies = new BoundedPrioritySet<Movie>(9);

  private String trailerFileName(final Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }

  private File trailerFilePath(final Movie movie) {
    return new File(Application.trailersDirectory, trailerFileName(movie));
  }

  protected void clearStaleDataBackgroundEntryPoint() {
    clearDirectory(Application.trailersDirectory);
  }

  @SuppressWarnings("unchecked")
  private List<List<Movie>> getOrderedMovies(final List<Movie> movies) {
    final List<Movie> moviesWithoutTrailers = new ArrayList<Movie>();
    final List<Movie> moviesWithTrailers = new ArrayList<Movie>();

    final long now = new Date().getTime();

    for (final Movie movie : movies) {
      final File file = trailerFilePath(movie);
      if (!file.exists()) {
        moviesWithoutTrailers.add(movie);
      } else {
        final long writeTime = file.lastModified();
        final long span = Math.abs(writeTime - now);

        if (span > 2 * Constants.ONE_DAY) {
          moviesWithTrailers.add(movie);
        }
      }
    }

    return Arrays.asList(moviesWithoutTrailers, moviesWithTrailers);
  }

  public void update(final List<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Trailers", runnable, this.lock, false/*visible*/);
  }

  private void updateBackgroundEntryPoint(final List<Movie> movies) {
    final List<List<Movie>> orderedMovies = getOrderedMovies(movies);

    final String url = "http://" + Application.host + ".appspot.com/LookupTrailerListings?q=index";
    final String indexText = NetworkUtilities.downloadString(url, false);
    if (indexText == null) {
      return;
    }

    final Map<String, List<String>> index = generateIndex(indexText);

    for (final List<Movie> values : orderedMovies) {
      downloadTrailers(values, index);
    }
  }

  private void downloadMovieTrailer(final Movie movie, final Map<String, List<String>> index) {
    if (movie == null) {
      return;
    }

    final String bestKey = EditDistance.findClosestMatch(movie.getCanonicalTitle().toLowerCase(), index.keySet());
    if (bestKey == null) {
      // no trailer for this movie.  record that fact.  we'll try again later
      FileUtilities.writeStringCollection(new ArrayList<String>(), trailerFilePath(movie));
      return;
    }

    final List<String> studioAndLocation = index.get(bestKey);
    final String studio = studioAndLocation.get(0);
    final String location = studioAndLocation.get(1);

    final String url = "http://" + Application
        .host + ".appspot.com/LookupTrailerListings?studio=" + studio + "&name=" + location;
    final String trailersString = NetworkUtilities.downloadString(url, false);

    if (trailersString == null) {
      // didn't get any data.  ignore this for now.
      return;
    }

    final List<String> trailers = Arrays.asList(trailersString.split("\n"));
    FileUtilities.writeString(trailers.get(0), trailerFilePath(movie));
    Application.refresh();
  }

  private void downloadTrailers(final List<Movie> movies, final Map<String, List<String>> index) {
    final Set<Movie> moviesSet = new TreeSet<Movie>(movies);

    Movie movie;
    do {
      movie = this.prioritizedMovies.removeAny(moviesSet);
      downloadMovieTrailer(movie, index);
    } while (movie != null && !this.shutdown);
  }

  private Map<String, List<String>> generateIndex(final String indexText) {
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

  public String getTrailer(final Movie movie) {
    return FileUtilities.readString(trailerFilePath(movie));
  }

  public void prioritizeMovie(final Movie movie) {
    if (trailerFilePath(movie).exists()) {
      return;
    }

    this.prioritizedMovies.add(movie);
  }
}
