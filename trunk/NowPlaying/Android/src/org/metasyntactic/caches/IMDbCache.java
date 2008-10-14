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

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class IMDbCache {
  private final Object lock = new Object();


  private String movieFilePath(Movie movie) {
    return new File(Application.imdbDirectory,
        FileUtilities.sanitizeFileName(movie.getCanonicalTitle())).getAbsolutePath();
  }


  public void update(final List<Movie> movies) {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, lock, false);
  }


  private void updateBackgroundEntryPoint(List<Movie> movies) {
    deleteObsoleteAddresses(movies);

  }


  private void deleteObsoleteAddresses(List<Movie> movies) {
    for (Movie movie : movies) {
      String path = movieFilePath(movie);
      if (new File(path).exists()) {
        continue;
      }

      try {
        String url = "http://metaboxoffice2.appspot.com/LookupIMDbListings?q=" +
            URLEncoder.encode(movie.getCanonicalTitle(), "UTF-8");

        String imdbAddress = NetworkUtilities.downloadString(url, false);

        if (!StringUtilities.isNullOrEmpty(imdbAddress)) {
          FileUtilities.writeObject(imdbAddress, movieFilePath(movie));
          Application.refresh();
        }
      } catch (UnsupportedEncodingException e) {
        throw new RuntimeException(e);
      }
    }
  }


  public String imdbAddressForMovie(Movie movie) {
    return FileUtilities.readObject(movieFilePath(movie));
  }
}