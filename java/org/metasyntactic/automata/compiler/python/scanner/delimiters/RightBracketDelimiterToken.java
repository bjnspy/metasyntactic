package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class RightBracketDelimiterToken extends DelimiterToken {
  public static final RightBracketDelimiterToken instance = new RightBracketDelimiterToken();

  private RightBracketDelimiterToken() {
    super("]");
  }
}
