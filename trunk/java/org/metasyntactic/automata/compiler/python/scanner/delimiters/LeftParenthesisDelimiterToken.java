package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class LeftParenthesisDelimiterToken extends DelimiterToken {
  public static final LeftParenthesisDelimiterToken instance = new LeftParenthesisDelimiterToken();

  private LeftParenthesisDelimiterToken() {
    super("(");
  }
}
