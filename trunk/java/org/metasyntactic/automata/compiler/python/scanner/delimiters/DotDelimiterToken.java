package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class DotDelimiterToken extends DelimiterToken {
  public static final DotDelimiterToken instance = new DotDelimiterToken();

  private DotDelimiterToken() {
    super(".");
  }
}
