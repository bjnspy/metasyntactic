package com.google.automata.compiler.python.scanner.delimiters;

public class RightShiftEqualsDelimiterToken extends DelimiterToken {
  public static final RightShiftEqualsDelimiterToken instance = new RightShiftEqualsDelimiterToken();

  private RightShiftEqualsDelimiterToken() {
    super(">>=");
  }
}
