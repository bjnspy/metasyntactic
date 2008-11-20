package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class AndEqualsDelimiterToken extends DelimiterToken {
  public static final AndEqualsDelimiterToken instance = new AndEqualsDelimiterToken();

  private AndEqualsDelimiterToken() {
    super("&=");
  }
}
