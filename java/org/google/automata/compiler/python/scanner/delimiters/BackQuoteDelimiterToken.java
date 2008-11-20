package com.google.automata.compiler.python.scanner.delimiters;

public class BackQuoteDelimiterToken extends DelimiterToken {
  public static final BackQuoteDelimiterToken instance = new BackQuoteDelimiterToken();

  private BackQuoteDelimiterToken() {
    super("`");
  }
}
