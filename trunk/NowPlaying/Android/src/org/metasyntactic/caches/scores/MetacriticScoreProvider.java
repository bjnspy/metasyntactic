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

package org.metasyntactic.caches.scores;

import org.metasyntactic.Application;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.w3c.dom.Element;

import java.util.HashMap;
import java.util.Map;

public class MetacriticScoreProvider extends AbstractScoreProvider {
  public MetacriticScoreProvider(ScoreCache scoreCache) {
    super(scoreCache);
  }


  @Override
  protected String getProviderName() {
    return "Metacritic";
  }


  @Override
  protected String lookupServerHash() {
    String address = "http://" + Application.host + ".appspot.com/LookupMovieRatings?q=metacritic&format=xml&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }


  @Override
  protected Map<String, Score> lookupServerScores() {

    String address = "http://" + Application.host + ".appspot.com/LookupMovieRatings?q=metacritic&format=xml";
    Element resultElement = NetworkUtilities.downloadXml(address, true);

    if (resultElement != null) {
      Map<String, Score> ratings = new HashMap<String, Score>();

      for (Element movieElement : children(resultElement)) {
        String title = movieElement.getAttribute("title");
        String link = movieElement.getAttribute("link");
        String synopsis = movieElement.getAttribute("synopsis");
        String value = movieElement.getAttribute("score");

        if (value.equals("xx")) {
          value = "-1";
        }

        Score score = new Score(title, synopsis, value, "metacritic", link);
        ratings.put(score.getCanonicalTitle(), score);
      }

      return ratings;
    }

    return null;
  }
}