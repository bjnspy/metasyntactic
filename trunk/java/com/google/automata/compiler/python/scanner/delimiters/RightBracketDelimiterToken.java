package com.google.automata.compiler.python.scanner.delimiters;

import com.google.automata.compiler.python.scanner.PythonToken;

public class RightBracketDelimiterToken extends DelimiterToken {
  public static final RightBracketDelimiterToken instance = new RightBracketDelimiterToken();

  private RightBracketDelimiterToken() {
    super("]");
  }
}
