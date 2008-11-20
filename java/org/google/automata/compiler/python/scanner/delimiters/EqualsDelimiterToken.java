package com.google.automata.compiler.python.scanner.delimiters;

public class EqualsDelimiterToken extends DelimiterToken {
  public static final EqualsDelimiterToken instance = new EqualsDelimiterToken();

  private EqualsDelimiterToken() {
    super("=");
  }
}
