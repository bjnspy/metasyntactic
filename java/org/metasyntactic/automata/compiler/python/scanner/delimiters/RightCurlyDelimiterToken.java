package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class RightCurlyDelimiterToken extends DelimiterToken {
  public static final RightCurlyDelimiterToken instance = new RightCurlyDelimiterToken();

  private RightCurlyDelimiterToken() {
    super("}");
  }
}
