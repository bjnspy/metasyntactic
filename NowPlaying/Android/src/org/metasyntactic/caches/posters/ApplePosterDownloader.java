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

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.utilities.difference.EditDistance;

import java.util.HashMap;
import java.util.Map;

public class ApplePosterDownloader {
  private static Map<String, String> movieNameToPosterMap;

  private ApplePosterDownloader() {

  }

  public static byte[] download(final Movie movie) {
    createMap();

    if (movieNameToPosterMap == null) {
      return null;
    }

    final String key = EditDistance.findClosestMatch(movie.getCanonicalTitle(), movieNameToPosterMap.keySet());
    if (key == null) {
      return null;
    }

    final String address = movieNameToPosterMap.get(key);
    return NetworkUtilities.download(address, false);
  }

  private static void createMap() {
    if (movieNameToPosterMap != null) {
      return;
    }

    final String index = NetworkUtilities.downloadString("http://" + NowPlayingApplication.host + ".appspot.com/LookupPosterListings", false);
    if (isNullOrEmpty(index)) {
      return;
    }

    final Map<String, String> result = new HashMap<String, String>();

    for (final String row : index.split("\n")) {
      final String[] columns = row.split("\t");
      if (columns.length >= 2) {
        final String movieName = Movie.makeCanonical(columns[0]);
        final String posterUrl = columns[1];

        result.put(movieName, posterUrl);
      }
    }

    movieNameToPosterMap = result;
  }

  public static void onLowMemory() {
    movieNameToPosterMap = null;
  }
}
