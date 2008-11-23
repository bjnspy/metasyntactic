package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class RightParenthesisDelimiterToken extends DelimiterToken {
  public static final RightParenthesisDelimiterToken instance = new RightParenthesisDelimiterToken();

  private RightParenthesisDelimiterToken() {
    super(")");
  }
}
