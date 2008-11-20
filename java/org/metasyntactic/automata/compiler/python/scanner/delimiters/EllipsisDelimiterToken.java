package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class EllipsisDelimiterToken extends DelimiterToken {
  public static final EllipsisDelimiterToken instance = new EllipsisDelimiterToken();

  private EllipsisDelimiterToken() {
    super("...");
  }
}