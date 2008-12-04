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
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.List;

public class IMDbCache extends AbstractCache {
  private String movieFileName(final Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }

  private File movieFilePath(final Movie movie) {
    return new File(Application.imdbDirectory, movieFileName(movie));
  }

  public void update(final List<Movie> movies) {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Upate IMDb", runnable, this.lock, false);
  }

  private void updateBackgroundEntryPoint(final List<Movie> movies) {
    downloadImdbAddresses(movies);
  }

  private void downloadImdbAddresses(final List<Movie> movies) {
    for (final Movie movie : movies) {
      if (shutdown) {
        break;
      }

      // Nothing to do if we already have a valid imdb address
      if (!StringUtilities.isNullOrEmpty(movie.getIMDbAddress())) {
        continue;
      }

      final File path = movieFilePath(movie);
      if (path.exists()) {
        continue;
      }

      final String url = "http://" + Application.host + ".appspot.com/LookupIMDbListings?q=" +
                         StringUtilities.urlEncode(movie.getCanonicalTitle());

      final String imdbAddress = NetworkUtilities.downloadString(url, false);

      if (!isNullOrEmpty(imdbAddress)) {
        FileUtilities.writeString(imdbAddress, movieFilePath(movie));
        Application.refresh();
      }
    }
  }

  public String getIMDbAddress(final Movie movie) {
    return FileUtilities.readString(movieFilePath(movie));
  }

  protected void clearStaleDataBackgroundEntryPoint() {
    clearDirectory(Application.imdbDirectory);
  }
}