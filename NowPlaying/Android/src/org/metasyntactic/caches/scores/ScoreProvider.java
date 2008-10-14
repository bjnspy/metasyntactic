package org.metasyntactic.caches.scores;

import org.metasyntactic.data.Score;

import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public interface ScoreProvider {
  Map<String, Score> getScores();
  void update();
}
