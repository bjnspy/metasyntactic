package com.google.automata.compiler.python.scanner.delimiters;

public class MinusEqualsDelimiterToken extends DelimiterToken {
  public static final MinusEqualsDelimiterToken instance = new MinusEqualsDelimiterToken();

  private MinusEqualsDelimiterToken() {
    super("-=");
  }
}
