package org.metasyntactic.caches.scores;

import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.w3c.dom.Element;

import java.util.LinkedHashMap;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class RottenTomatoesScoreProvider extends AbstractScoreProvider {
  public RottenTomatoesScoreProvider(ScoreCache scoreCache) {
    super(scoreCache);
  }


  protected String getProviderName() {
    return "RottenTomatoes";
  }


  protected String lookupServerHash() {
    String address = "http://metaboxoffice2.appspot.com/LookupMovieRatings?q=rottentomatoes&format=xml&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }


  protected Map<String, Score> lookupServerRatings() {
    Element resultElement =
        NetworkUtilities.downloadXml("http://metaboxoffice2.appspot.com/LookupMovieRatings?q=rottentomates&format=xml",
            true);

    if (resultElement != null) {
      Map<String, Score> ratings = new LinkedHashMap<String, Score>();

      for (Element movieElement : children(resultElement)) {
        String title = movieElement.getAttribute("title");
        String link = movieElement.getAttribute("link");
        String synopsis = movieElement.getAttribute("synopsis");
        String value = movieElement.getAttribute("score");

        Score score = new Score(title, synopsis, value, "rottentomatoes", link);

        ratings.put(score.getCanonicalTitle(), score);
      }

      return ratings;
    }

    return null;
  }
}