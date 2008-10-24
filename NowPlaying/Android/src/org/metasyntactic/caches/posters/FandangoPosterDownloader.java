package org.metasyntactic.caches.posters;

import org.metasyntactic.Application;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.XmlUtilities;
import static org.metasyntactic.utilities.XmlUtilities.*;
import org.metasyntactic.utilities.difference.EditDistance;
import org.w3c.dom.Element;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class FandangoPosterDownloader {
  private static String lastPostalCode;
  private static Map<String, String> movieNameToPosterMap;


  public static byte[] download(Movie movie, String postalCode) {
    createMovieMap(postalCode);

    if (movieNameToPosterMap == null) {
      return null;
    }

    String key = EditDistance.findClosestMatch(movie.getCanonicalTitle(), movieNameToPosterMap.keySet());
    if (key == null) {
      return null;
    }

    String posterUrl = movieNameToPosterMap.get(key);
    int lastSlashIndex = posterUrl.lastIndexOf('/');
    if (lastSlashIndex > 0) {
      posterUrl = posterUrl.substring(0, lastSlashIndex) + "/"
          + StringUtilities.urlEncode(posterUrl.substring(lastSlashIndex + 1));
    }

    return NetworkUtilities.download(posterUrl, false);
  }


  private static void createMovieMap(String postalCode) {
    if (StringUtilities.isNullOrEmpty(postalCode)) {
      return;
    }

    if (postalCode.equals(lastPostalCode)) {
      return;
    }
    lastPostalCode = postalCode;

    Calendar calendar = Calendar.getInstance();
    calendar.setTime(new Date());

    String url = "http://" + Application.host + ".appspot.com/LookupTheaterListings?q=" + trimPostalCode(
        postalCode) + "&date="
        + calendar.get(Calendar.YEAR) + "-"
        + (calendar.get(Calendar.MONTH) + 1) + "-"
        + calendar.get(Calendar.DAY_OF_MONTH) + "&provider=Fandango";

    Element element = NetworkUtilities.downloadXml(url, false);
    processFandangoElement(element);
  }


  private static void processFandangoElement(Element element) {
    Map<String, String> result = new HashMap<String, String>();

    Element dataElement = XmlUtilities.element(element, "data");
    Element moviesElement = XmlUtilities.element(dataElement, "movies");

    for (Element movieElement : children(moviesElement)) {
      String poster = movieElement.getAttribute("posterhref");
      String title = Movie.makeCanonical(text(element(movieElement, "title")));

      if (StringUtilities.isNullOrEmpty(poster) || StringUtilities.isNullOrEmpty(title)) {
        continue;
      }

      result.put(title, poster);
    }

    if (result.isEmpty()) {
      return;
    }

    movieNameToPosterMap = result;
  }


  private static String trimPostalCode(String postalCode) {
    StringBuffer buffer = new StringBuffer();
    for (char c : postalCode.toCharArray()) {
      if (Character.isLetterOrDigit(c)) {
        buffer.append(c);
      }
    }
    return buffer.toString();
  }
}
