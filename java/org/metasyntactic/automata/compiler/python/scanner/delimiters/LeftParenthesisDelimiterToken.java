package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

public class LeftParenthesisDelimiterToken extends DelimiterToken {
  public static final LeftParenthesisDelimiterToken instance = new LeftParenthesisDelimiterToken();

  private LeftParenthesisDelimiterToken() {
    super("(");
  }
}
