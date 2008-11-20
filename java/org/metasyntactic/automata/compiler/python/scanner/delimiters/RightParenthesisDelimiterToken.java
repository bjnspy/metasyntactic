package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

public class RightParenthesisDelimiterToken extends DelimiterToken {
  public static final RightParenthesisDelimiterToken instance = new RightParenthesisDelimiterToken();

  private RightParenthesisDelimiterToken() {
    super(")");
  }
}
