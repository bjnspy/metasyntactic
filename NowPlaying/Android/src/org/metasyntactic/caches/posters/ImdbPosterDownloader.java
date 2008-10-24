package org.metasyntactic.caches.posters;

import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.XmlUtilities.element;
import static org.metasyntactic.utilities.XmlUtilities.text;
import org.w3c.dom.Element;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ImdbPosterDownloader {


  public static byte[] download(Movie movie) {
    return NetworkUtilities.download(getImageUrl(getImdbId(movie)), false);
  }


  private static String getImdbId(Movie movie) {
    String url =
        "http://www.trynt.com/movie-imdb-api/v2/?t=" + StringUtilities.urlEncode(movie.getCanonicalTitle());
    Element tryntElement = NetworkUtilities.downloadXml(url, false);

    return text(element(element(tryntElement, "movie-imdb"), "matched-id"));
  }


  private static String getImageUrl(String imdbId) {
    if (StringUtilities.isNullOrEmpty(imdbId)) {
      return null;
    }

    String address = "http://www.trynt.com/movie-imdb-api/v2/?i=" + imdbId;
    Element tryntElement = NetworkUtilities.downloadXml(address, false);
    return text(element(element(tryntElement, "movie-imdb"), "picture-url"));
  }
}
