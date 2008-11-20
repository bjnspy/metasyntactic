package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class ExclusiveOrEqualsDelimiterToken extends DelimiterToken {
  public static final ExclusiveOrEqualsDelimiterToken instance = new ExclusiveOrEqualsDelimiterToken();

  private ExclusiveOrEqualsDelimiterToken() {
    super("^=");
  }
}
