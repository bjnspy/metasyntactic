package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class SemicolonDelimiterToken extends DelimiterToken {
  public static final SemicolonDelimiterToken instance = new SemicolonDelimiterToken();

  private SemicolonDelimiterToken() {
    super(";");
  }
}
