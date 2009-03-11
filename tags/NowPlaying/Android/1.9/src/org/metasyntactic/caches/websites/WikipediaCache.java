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
package org.metasyntactic.caches.websites;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractMovieCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;

public class WikipediaCache extends AbstractMovieCache {

  public WikipediaCache(final NowPlayingModel model) {
    super(model);
  }

  private static String movieFileName(final Movie movie) {
    return FileUtilities.sanitizeFileName(movie.getCanonicalTitle());
  }

  private static File movieFilePath(final Movie movie) {
    return new File(NowPlayingApplication.wikipediaDirectory, movieFileName(movie));
  }

  public void update(final List<Movie> movies) {
    addPrimaryMovies(movies);
  }

  public void update(final Movie movie) {
    addPrimaryMovie(movie);
  }

  @Override protected void updateMovieDetails(final Movie movie) {
    if (movie == null) {
      return;
    }

    final File path = movieFilePath(movie);
    if (path.exists()) {
      final String address = FileUtilities.readString(path);
      if (address.length() > 0) {
        return;
      }

      if (FileUtilities.daysSinceNow(path) < 3) {
        return;
      }
    }

    final String url = "http://" + NowPlayingApplication.host + ".appspot.com/LookupWikipediaListings?q=" + StringUtilities
    .urlEncode(movie.getCanonicalTitle());

    final String imdbAddress = NetworkUtilities.downloadString(url, false);
    if (imdbAddress == null) {
      return;
    }

    FileUtilities.writeString(imdbAddress, path);
    NowPlayingApplication.refresh();
  }

  public static String getAddress(final Movie movie) {
    return FileUtilities.readString(movieFilePath(movie));
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.singletonList(NowPlayingApplication.wikipediaDirectory);
  }
}