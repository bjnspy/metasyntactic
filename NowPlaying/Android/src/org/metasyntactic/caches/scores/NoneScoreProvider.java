package org.metasyntactic.caches.scores;

import org.metasyntactic.data.Score;

import java.util.Collections;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NoneScoreProvider extends AbstractScoreProvider {
  public NoneScoreProvider(ScoreCache scoreCache) {
    super(scoreCache);
  }


  protected String getProviderName() {
    return "None";
  }


  protected String lookupServerHash() {
    return "0";
  }


  protected Map<String, Score> lookupServerScores() {
    return Collections.emptyMap();
  }
}
