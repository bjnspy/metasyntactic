package com.google.automata.compiler.python.scanner.delimiters;

public class ExponentEqualsDelimiterToken extends DelimiterToken {
  public static final ExponentEqualsDelimiterToken instance = new ExponentEqualsDelimiterToken();

  private ExponentEqualsDelimiterToken() {
    super("**=");
  }
}
