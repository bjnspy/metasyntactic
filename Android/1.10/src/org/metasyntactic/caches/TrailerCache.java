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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

public class TrailerCache extends AbstractMovieCache {
  public TrailerCache(final NowPlayingModel model) {
    super(model);
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

  public void update(final Iterable<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        addMovies(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Trailers", runnable, lock, false/* visible */);
  }

  private void addMovies(final Iterable<Movie> movies) {
    final List<Movie> moviesWithoutTrailers = new ArrayList<Movie>();
    final List<Movie> moviesWithTrailers = new ArrayList<Movie>();

    for (final Movie movie : movies) {
      if (shutdown) { return; }
      final File file = trailerFilePath(movie);
      if (file.exists()) {
        if (FileUtilities.daysSinceNow(file) > 3) {
          moviesWithTrailers.add(movie);
        }
      } else {
        moviesWithoutTrailers.add(movie);
      }
    }

    addPrimaryMovies(moviesWithoutTrailers);
    addSecondaryMovies(moviesWithTrailers);
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

  @Override protected void updateMovieDetails(final Movie movie) {
    if (movie == null) {
      return;
    }

    final File trailerFile = trailerFilePath(movie);
    if (trailerFile.exists()) {
      return;
    }

    final Map<String, List<String>> localIndex = getIndex();

    final String bestKey = EditDistance.findClosestMatch(movie.getCanonicalTitle().toLowerCase(), localIndex.keySet());
    if (bestKey == null) {
      // no trailer for this movie. record that fact. we'll try again later
      FileUtilities.writeStringCollection(new ArrayList<String>(), trailerFilePath(movie));
      return;
    }

    final List<String> studioAndLocation = localIndex.get(bestKey);
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

  @Override
  public void onLowMemory() {
    super.onLowMemory();
    index = null;
  }
}
