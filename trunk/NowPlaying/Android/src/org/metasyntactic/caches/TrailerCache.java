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
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TrailerCache {
  private final Object lock = new Object();


  private String trailerFileName(Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }


  private File trailerFilePath(Movie movie) {
    return new File(Application.trailersDirectory, trailerFileName(movie));
  }


  private void deleteObsoleteTrailers(List<Movie> movies) {
    File trailersDir = Application.trailersDirectory;
    Set<String> fileNames = new HashSet<String>(Arrays.asList(trailersDir.list()));

    for (Movie movie : movies) {
      fileNames.remove(trailerFileName(movie));
    }

    long now = new Date().getTime();

    for (String fileName : fileNames) {
      File file = new File(trailersDir, fileName);
      if (file.exists()) {
        long writeTime = file.lastModified();
        long span = Math.abs(writeTime - now);

        if (span > (4 * Constants.ONE_WEEK)) {
          file.delete();
        }
      }
    }
  }


  private List<List<Movie>> getOrderedMovies(List<Movie> movies) {
    List<Movie> moviesWithoutTrailers = new ArrayList<Movie>();
    List<Movie> moviesWithTrailers = new ArrayList<Movie>();

    long now = new Date().getTime();

    for (Movie movie : movies) {
      File file = trailerFilePath(movie);
      if (!file.exists()) {
        moviesWithoutTrailers.add(movie);
      } else {
        long writeTime = file.lastModified();
        long span = Math.abs(writeTime - now);

        if (span > (2 * Constants.ONE_DAY)) {
          moviesWithTrailers.add(movie);
        }
      }
    }

    return Arrays.asList(moviesWithoutTrailers, moviesWithTrailers);
  }


  public void update(final List<Movie> movies) {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, false/*visible*/);
  }


  private void updateBackgroundEntryPoint(final List<Movie> movies) {
    deleteObsoleteTrailers(movies);

    List<List<Movie>> orderedMovies = getOrderedMovies(movies);

    String url = "http://metaboxoffice2.appspot.com/LookupTrailerListings?q=index";
    String indexText = NetworkUtilities.downloadString(url, false);
    if (indexText == null) {
      return;
    }

    Map<String, List<String>> index = generateIndex(indexText);

    for (List<Movie> values : orderedMovies) {
      downloadTrailers(values, index);
    }
  }


  private void downloadMovieTrailer(Movie movie, Map<String, List<String>> index) {
    String bestKey = EditDistance.findClosestMatch(movie.getCanonicalTitle().toLowerCase(), index.keySet());
    if (bestKey == null) {
      // no trailer for this movie.  record that fact.  we'll try again later
      FileUtilities.writeStringCollection(new ArrayList<String>(), trailerFilePath(movie));
      return;
    }

    List<String> studioAndLocation = index.get(bestKey);
    String studio = studioAndLocation.get(0);
    String location = studioAndLocation.get(1);

    String url = "http://metaboxoffice2.appspot.com/LookupTrailerListings?studio=" + studio + "&name=" + location;
    String trailersString = NetworkUtilities.downloadString(url, false);

    if (trailersString == null) {
      // didn't get any data.  ignore this for now.
      return;
    }

    List<String> trailers = Arrays.asList(trailersString.split("\n"));
    FileUtilities.writeStringCollection(trailers, trailerFilePath(movie));
    Application.refresh();
  }


  private void downloadTrailers(List<Movie> movies, Map<String, List<String>> index) {
    for (Movie movie : movies) {
      downloadMovieTrailer(movie, index);
    }
  }


  private Map<String, List<String>> generateIndex(String indexText) {
    Map<String, List<String>> index = new HashMap<String, List<String>>();

    for (String row : indexText.split("\n")) {
      String[] values = row.split("\t");
      if (values.length != 3) {
        continue;
      }

      String fullTitle = values[0];
      String studio = values[1];
      String location = values[2];

      index.put(fullTitle.toLowerCase(), Arrays.asList(studio, location));
    }

    return index;
  }


  public List<String> getTrailers(Movie movie) {
    List<String> trailers = FileUtilities.readStringList(trailerFilePath(movie));
    if (trailers == null) {
      return Collections.emptyList();
    }
    return trailers;
  }
}
