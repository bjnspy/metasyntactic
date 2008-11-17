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

package org.metasyntactic.utilities.difference;

import org.metasyntactic.utilities.StringUtilities;

import java.util.List;

public class EditDistance {
  private EditDistance() {
  }

  public static int getEditDistance(final String source, final String target) {
    return getEditDistance(source, target, -1);
  }

  public static int getEditDistance(final String source, final String target, final int costThreshold) {
    final int sourceLength = StringUtilities.isNullOrEmpty(source) ? 0 : source.length();
    final int targetLength = StringUtilities.isNullOrEmpty(target) ? 0 : target.length();

    if (sourceLength == 0) {
      return targetLength;
    }

    if (targetLength == 0) {
      return sourceLength;
    }

    if (costThreshold >= 0) {
      final int minimumTLength = sourceLength - costThreshold;

      if (targetLength < minimumTLength) {
        return Integer.MAX_VALUE;
      }

      final int minimumSLength = targetLength - costThreshold;

      if (sourceLength < minimumSLength) {
        return Integer.MAX_VALUE;
      }
    }

    final int[][] matrix = new int[sourceLength + 1][targetLength + 1];

    for (int i = 0; i <= sourceLength; i++) {
      matrix[i][0] = i;
    }

    for (int i = 0; i <= targetLength; i++) {
      matrix[0][i] = i;
    }

    final char[] sourceChars = source.toCharArray();
    final char[] destChars = target.toCharArray();

    for (int i = 1; i <= sourceLength; i++) {
      boolean rowIsUnderThreshold = costThreshold < 0;

      final char sourceI = sourceChars[i - 1];
      for (int j = 1; j <= targetLength; j++) {
        final char targetJ = destChars[j - 1];

        int cost = 0;
        if (sourceI != targetJ) {
          cost = 1;
        }

        final int totalCost = Math.min(cost + matrix[i - 1][j - 1], Math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1));

        matrix[i][j] = totalCost;

        if (costThreshold >= 0) {
          rowIsUnderThreshold |= totalCost <= costThreshold;
        }
      }

      if (!rowIsUnderThreshold) {
        return Integer.MAX_VALUE;
      }
    }

    return matrix[sourceLength][targetLength];
  }

  public static boolean areSimilar(final String s1, final String s2) {
    if (s1 == null || s2 == null) {
      return false;
    }

    if (s1.length() > 4 && s2.length() > 4) {
      if (s1.contains(s2) || s2.contains(s1)) {
        return true;
      }
    }

    final int threshold = threshold(s1);
    final int diff = getEditDistance(s1, s2, threshold);
    return diff <= threshold;
  }

  static int threshold(final String string) {
    return Math.max(string.length() / 4, 1);
  }

  public static int findClosestMatchIndex(final String string, final List<String> list) {
    int bestDistance = Integer.MAX_VALUE;
    int bestIndex = -1;

    if ((bestIndex = list.indexOf(string)) != -1) {
      return bestIndex;
    }

    if (string.length() > 4) {
      for (int i = 0; i < list.size(); i++) {
        final String other = list.get(i);
        if (other.length() > 4 && string.contains(other) || other.contains(string)) {
          return i;
        }
      }
    }

    for (int i = 0; i < list.size(); i++) {
      final String value = list.get(i);

      final int distance = getEditDistance(string, value, threshold(string));

      if (distance < bestDistance) {
        bestIndex = i;
        bestDistance = distance;
      }
    }

    if (bestIndex != -1 && areSimilar(string, list.get(bestIndex))) {
      return bestIndex;
    }

    return -1;
  }

  public static String findClosestMatch(final String string, final List<String> list) {
    final int index = findClosestMatchIndex(string, list);
    if (index == -1) {
      return null;
    }

    return list.get(index);
  }

  public static String findClosestMatch(final String string, final java.util.Collection<String> set) {
    if (set.contains(string)) {
      return string;
    }

    if (string.length() > 4) {
      for (final String other : set) {
        if (other.length() > 4 && string.contains(other) || other.contains(string)) {
          return other;
        }
      }
    }

    int bestDistance = Integer.MAX_VALUE;
    String bestValue = null;

    for (final String value : set) {
      final int distance = getEditDistance(string, value, threshold(string));

      if (distance < bestDistance) {
        bestDistance = distance;
        bestValue = value;
      }
    }

    if (bestValue != null && areSimilar(string, bestValue)) {
      return bestValue;
    }

    return null;
  }
}