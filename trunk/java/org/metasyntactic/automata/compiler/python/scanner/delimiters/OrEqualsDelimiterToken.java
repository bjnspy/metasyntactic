package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class OrEqualsDelimiterToken extends DelimiterToken {
  public static final OrEqualsDelimiterToken instance = new OrEqualsDelimiterToken();

  private OrEqualsDelimiterToken() {
    super("|=");
  }
}
