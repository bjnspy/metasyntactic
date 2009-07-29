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
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.utilities.XmlUtilities;
import static org.metasyntactic.utilities.XmlUtilities.children;
import static org.metasyntactic.utilities.XmlUtilities.element;
import static org.metasyntactic.utilities.XmlUtilities.text;
import org.metasyntactic.utilities.difference.EditDistance;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class FandangoPosterDownloader {
  private static Object lock = new Object();
  private static Map<String, String> movieNameToPosterMap;

  private FandangoPosterDownloader() {
  }

  public static byte[] download(final Movie movie) {
    Map<String, String> map = createMovieMap();

    if (map == null) {
      return null;
    }

    final String key = EditDistance.findClosestMatch(movie.getCanonicalTitle(),
        map.keySet());
    if (key == null) {
      return null;
    }

    String posterUrl = map.get(key);
    final int lastSlashIndex = posterUrl.lastIndexOf('/');
    if (lastSlashIndex > 0) {
      posterUrl = posterUrl.substring(0, lastSlashIndex) + '/'
          + StringUtilities.urlEncode(posterUrl.substring(lastSlashIndex + 1));
    }

    return NetworkUtilities.download(posterUrl, false);
  }

  private static Map<String, String> createMovieMap() {
    synchronized (lock) {
      if (movieNameToPosterMap != null) {
        return movieNameToPosterMap;
      }

      final Calendar calendar = Calendar.getInstance();
      calendar.setTime(new Date());

      final String url = "http://" + NowPlayingApplication.host
          + ".appspot.com/LookupTheaterListings?q=10036"
          + "&date=" + calendar.get(Calendar.YEAR)
          + '-' + (calendar.get(Calendar.MONTH) + 1) + '-'
          + calendar.get(Calendar.DAY_OF_MONTH) + "&provider=Fandango";

      final Element element = NetworkUtilities.downloadXml(url, false);
      return processFandangoElement(element);
    }
  }

  private static Map<String, String> processFandangoElement(final Node element) {
    final Map<String, String> result = new HashMap<String, String>();

    final Element dataElement = XmlUtilities.element(element, "data");
    final Element moviesElement = XmlUtilities.element(dataElement, "movies");

    for (final Element movieElement : children(moviesElement)) {
      final String poster = movieElement.getAttribute("posterhref");
      final String title = Movie.makeCanonical(text(element(movieElement,
          "title")));

      if (isNullOrEmpty(poster) || isNullOrEmpty(title)) {
        continue;
      }

      result.put(title, poster);
    }

    if (result.isEmpty()) {
      return null;
    }

    movieNameToPosterMap = result;
    return movieNameToPosterMap;
  }

  public static void onLowMemory() {
    synchronized (lock) {
      movieNameToPosterMap = null;
    }
  }
}
