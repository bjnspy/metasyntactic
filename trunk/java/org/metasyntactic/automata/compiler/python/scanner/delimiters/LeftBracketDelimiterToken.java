package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class LeftBracketDelimiterToken extends DelimiterToken {
  public static final LeftBracketDelimiterToken instance = new LeftBracketDelimiterToken();

  private LeftBracketDelimiterToken() {
    super("[");
  }
}
