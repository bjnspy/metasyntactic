package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class PlusEqualsDelimiterToken extends DelimiterToken {
  public static final PlusEqualsDelimiterToken instance = new PlusEqualsDelimiterToken();

  private PlusEqualsDelimiterToken() {
    super("+=");
  }
}
