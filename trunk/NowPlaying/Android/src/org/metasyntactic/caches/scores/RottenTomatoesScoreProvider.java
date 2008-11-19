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

public class RottenTomatoesScoreProvider extends AbstractScoreProvider {
  public RottenTomatoesScoreProvider(final ScoreCache scoreCache) {
    super(scoreCache);
  }

  @Override
  protected String getProviderName() {
    return "RottenTomatoes";
  }

  @Override
  protected String lookupServerHash() {
    final String address = "http://" +
                           Application
                               .host +
                                     ".appspot.com/LookupMovieRatings?q=rottentomatoes&format=xml&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }

  @Override
  protected Map<String, Score> lookupServerScores() {
    final Element resultElement = NetworkUtilities.downloadXml(
        "http://" + Application.host + ".appspot.com/LookupMovieRatings?q=rottentomates&format=xml", true);
    if (resultElement != null) {
      final Map<String, Score> ratings = new HashMap<String, Score>();

      for (final Element movieElement : children(resultElement)) {
        final String title = movieElement.getAttribute("title");
        final String link = movieElement.getAttribute("link");
        final String synopsis = movieElement.getAttribute("synopsis");
        final String value = movieElement.getAttribute("score");
        final Score score = new Score(title, synopsis, value, "rottentomatoes", link);

        ratings.put(score.getCanonicalTitle(), score);
      }

      return ratings;
    }

    return null;
  }
}