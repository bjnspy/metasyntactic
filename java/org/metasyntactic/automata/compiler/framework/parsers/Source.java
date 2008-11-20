package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.common.base.Preconditions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 4:01:21 PM
 * To change this template use File | Settings | File Templates.
 */
public class Source {
  private final String text;
  private List<String> lines;
  private int[] lineStartCharacterMap;

  public Source(String text) {
    Preconditions.checkNotNull(text);
    this.text = text;
  }

  public String getText() {
    return text;
  }

  public List<String> getLines() {
    computeLines();

    return lines;
  }

  private void computeLines() {
    if (lines == null) {
      List<String> tempLines = new ArrayList<String>();

      int lineStart = 0;

      StringBuilder builder = new StringBuilder();

      for (int i = 0; i < text.length(); i++) {
        char c = getChar(i);
        builder.append(c);

        switch (c) {
          case '\r':
            if ('\n' == getChar(i + 1)) {
              i++;
              builder.append('\n');
            }

            // fall through
          case '\n':
            tempLines.add(builder.toString());
            builder = new StringBuilder();
        }
      }

      int[] tempLineIndices = new int[tempLines.size() + 1];
      int currentIndex = 0;
      tempLineIndices[0] = currentIndex;

      for (int i = 0; i < tempLines.size(); i++) {
        currentIndex += tempLines.get(i).length();
        tempLineIndices[i + 1] = currentIndex;
      }

      lines = Collections.unmodifiableList(tempLines);
      lineStartCharacterMap = tempLineIndices;
    }
  }

  private char getChar(int i) {
    if (i >= text.length()) {
      return 0;
    }
    return text.charAt(i);
  }

  public Position getPosition(int characterIndex) {
    computeLines();
    final int index = Arrays.binarySearch(lineStartCharacterMap, characterIndex);
    final int line = index < 0 ? -index -2 : index;

    int lineStart = lineStartCharacterMap[line];
    final int character = characterIndex - lineStart;

    return new Position(line, character);
  }

  public Span getSpan(int start, int end) {
    return new SourceSpan(start, end);
  }

  private class SourceSpan extends AbstractSpan {
    private final int start;
    private final int end;

    public SourceSpan(int start, int end) {
      this.start = start;
      this.end = end;
    }

    @Override public Position getStartPosition() {
      return getPosition(start);
    }

    @Override public Position getEndPosition() {
      return getPosition(end);
    }
  }
}
