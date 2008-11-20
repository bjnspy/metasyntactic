package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class TimesEqualsDelimiterToken extends DelimiterToken {
  public static final TimesEqualsDelimiterToken instance = new TimesEqualsDelimiterToken();

  private TimesEqualsDelimiterToken() {
    super("*=");
  }
}
