package com.google.automata.compiler.python.scanner.delimiters;

public class CommaDelimiterToken extends DelimiterToken {
  public static final CommaDelimiterToken instance = new CommaDelimiterToken();

  private CommaDelimiterToken() {
    super(",");
  }
}
