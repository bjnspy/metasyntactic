package org.metasyntactic.caches.posters;

import org.metasyntactic.Application;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.util.HashMap;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ApplePosterDownloader {
  private static Map<String, String> movieNameToPosterMap;


  public static byte[] download(Movie movie) {
    createMap();

    if (movieNameToPosterMap == null) {
      return null;
    }

    String key = EditDistance.findClosestMatch(movie.getCanonicalTitle(), movieNameToPosterMap.keySet());
    if (key == null) {
      return null;
    }

    String address = movieNameToPosterMap.get(key);
    return NetworkUtilities.download(address, false);
  }


  private static void createMap() {
    if (movieNameToPosterMap != null) {
      return;
    }

    String index = NetworkUtilities.downloadString("http://" + Application.host + ".appspot.com/LookupPosterListings",
        false);
    if (StringUtilities.isNullOrEmpty(index)) {
      return;
    }

    Map<String, String> result = new HashMap<String, String>();

    for (String row : index.split("\n")) {
      String[] columns = row.split("\t");
      if (columns.length >= 2) {
        String movieName = Movie.makeCanonical(columns[0]);
        String posterUrl = columns[1];

        result.put(movieName, posterUrl);
      }
    }

    movieNameToPosterMap = result;
  }
}
