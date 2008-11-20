package com.google.automata.compiler.python.scanner.delimiters;

import com.google.automata.compiler.python.scanner.PythonToken;

public class RightParenthesisDelimiterToken extends DelimiterToken {
  public static final RightParenthesisDelimiterToken instance = new RightParenthesisDelimiterToken();

  private RightParenthesisDelimiterToken() {
    super(")");
  }
}
