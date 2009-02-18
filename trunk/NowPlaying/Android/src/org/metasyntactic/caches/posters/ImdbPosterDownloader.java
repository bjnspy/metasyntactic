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

import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import static org.metasyntactic.utilities.XmlUtilities.element;
import static org.metasyntactic.utilities.XmlUtilities.text;
import org.w3c.dom.Element;

public class ImdbPosterDownloader {
  public static byte[] download(final Movie movie) {
    return NetworkUtilities.download(getImageUrl(getImdbId(movie)), false);
  }

  private ImdbPosterDownloader() {

  }

  private static String getImdbId(final Movie movie) {
    final String url = "http://www.trynt.com/movie-imdb-api/v2/?t=" + StringUtilities.urlEncode(movie.getCanonicalTitle());
    final Element tryntElement = NetworkUtilities.downloadXml(url, false);

    return text(element(element(tryntElement, "movie-imdb"), "matched-id"));
  }

  private static String getImageUrl(final String imdbId) {
    if (isNullOrEmpty(imdbId)) {
      return null;
    }

    final String address = "http://www.trynt.com/movie-imdb-api/v2/?i=" + imdbId;
    final Element tryntElement = NetworkUtilities.downloadXml(address, false);
    return text(element(element(tryntElement, "movie-imdb"), "picture-url"));
  }
}
