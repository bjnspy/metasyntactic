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
import org.metasyntactic.utilities.StringUtilities;

import java.io.File;
import java.util.*;

public class IMDbCache {
  private final Object lock = new Object();


  private String movieFileName(Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }


  private File movieFilePath(Movie movie) {
    return new File(Application.imdbDirectory, movieFileName(movie));
  }


  public void update(final List<Movie> movies) {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Upate IMDb", runnable, lock, false);
  }


  private void updateBackgroundEntryPoint(List<Movie> movies) {
    deleteObsoleteAddresses(movies);
    downloadImdbAddresses(movies);
  }


  private void deleteObsoleteAddresses(List<Movie> movies) {
    File imdbDir = Application.imdbDirectory;
    Set<String> fileNames = new HashSet<String>(Arrays.asList(imdbDir.list()));

    for (Movie movie : movies) {
      fileNames.remove(movieFileName(movie));
    }

    long now = new Date().getTime();

    for (String fileName : fileNames) {
      File file = new File(imdbDir, fileName);
      if (file.exists()) {
        long writeTime = file.lastModified();
        long span = Math.abs(writeTime - now);

        if (span > (4 * Constants.ONE_WEEK)) {
          file.delete();
        }
      }
    }
  }


  private void downloadImdbAddresses(List<Movie> movies) {
    for (Movie movie : movies) {
      File path = movieFilePath(movie);
      if (path.exists()) {
        continue;
      }

      String url = "http://" + Application.host + ".appspot.com/LookupIMDbListings?q=" +
          StringUtilities.urlEncode(movie.getCanonicalTitle());

      String imdbAddress = NetworkUtilities.downloadString(url, false);

      if (!StringUtilities.isNullOrEmpty(imdbAddress)) {
        FileUtilities.writeString(imdbAddress, movieFilePath(movie));
        Application.refresh();
      }
    }
  }


  public String imdbAddressForMovie(Movie movie) {
    return FileUtilities.readString(movieFilePath(movie));
  }
}