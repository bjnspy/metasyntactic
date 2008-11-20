package com.google.automata.compiler.python.scanner.delimiters;

public class LeftShiftEqualsDelimiterToken extends DelimiterToken {
  public static final LeftShiftEqualsDelimiterToken instance = new LeftShiftEqualsDelimiterToken();

  private LeftShiftEqualsDelimiterToken() {
    super("<<=");
  }
}
