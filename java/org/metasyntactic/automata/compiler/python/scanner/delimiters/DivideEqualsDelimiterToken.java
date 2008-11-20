package com.google.automata.compiler.python.scanner.delimiters;

public class DivideEqualsDelimiterToken extends DelimiterToken {
  public static final DivideEqualsDelimiterToken instance = new DivideEqualsDelimiterToken();

  private DivideEqualsDelimiterToken() {
    super("/=");
  }
}
