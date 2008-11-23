package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class AtDelimiterToken extends DelimiterToken {
  public static final AtDelimiterToken instance = new AtDelimiterToken();

  private AtDelimiterToken() {
    super("@");
  }
}
