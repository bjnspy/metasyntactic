package org.metasyntactic.utilities.difference;

import org.metasyntactic.utilities.StringUtilities;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */

public class EditDistance {

  private EditDistance() {
  }


  public static int getEditDistance(String source, String target) {
    return getEditDistance(source, target, -1);
  }


  public static int getEditDistance(String source, String target, int costThreshold) {
    int sourceLength = StringUtilities.isNullOrEmpty(source) ? 0 : source.length();
    int targetLength = StringUtilities.isNullOrEmpty(target) ? 0 : target.length();

    if (sourceLength == 0) {
      return targetLength;
    }

    if (targetLength == 0) {
      return sourceLength;
    }

    if (costThreshold >= 0) {
      int minimumTLength = sourceLength - costThreshold;

      if (targetLength < minimumTLength) {
        return Integer.MAX_VALUE;
      }

      int minimumSLength = targetLength - costThreshold;

      if (sourceLength < minimumSLength) {
        return Integer.MAX_VALUE;
      }
    }

    int[][] matrix = new int[sourceLength + 1][targetLength + 1];

    for (int i = 0; i <= sourceLength; i++) {
      matrix[i][0] = i;
    }

    for (int i = 0; i <= targetLength; i++) {
      matrix[0][i] = i;
    }


    for (int i = 1; i <= sourceLength; i++) {
      char sourceI = source.charAt(i - 1);
      for (int j = 1; j <= targetLength; j++) {
        char targetJ = target.charAt(j - 1);

        int cost = 0;
        if (sourceI != targetJ) {
          cost = 1;
        }

        matrix[i][j] =
            Math.min(cost + matrix[i - 1][j - 1],
                Math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1));
      }
    }

    return matrix[sourceLength][targetLength];
  }


  public static boolean areSimilar(String s1, String s2) {
    if (s1 == null || s2 == null) {
      return false;
    }

    if (s1.length() > 4 && s2.length() > 4) {
      if (s1.contains(s2) ||
          s2.contains(s1)) {
        return true;
      }
    }

    int threshold = threshold(s1);
    int diff = getEditDistance(s1, s2, threshold);
    return (diff <= threshold);
  }


  static int threshold(String string) {
    int threshold = string.length() / 4;
    if (threshold == 0) {
      threshold = 1;
    }
    return threshold;
  }


  public static int findClosestMatchIndex(String string, List<String> list) {
    int bestDistance = Integer.MAX_VALUE;
    int bestIndex = -1;

    for (int i = 0; i < list.size(); i++) {
      String value = list.get(i);

      int distance = getEditDistance(string, value);

      if (distance < bestDistance) {
        bestIndex = i;
        bestDistance = distance;
      }
    }

    if (bestIndex != -1 &&
        areSimilar(list.get(bestIndex), string)) {
      return bestIndex;
    }

    return -1;
  }


  public static String findClosestMatch(String string, List<String> list) {
    int index = findClosestMatchIndex(string, list);
    if (index == -1) {
      return null;
    }

    return list.get(index);
  }
}