package org.metasyntactic.automata.compiler.python.scanner.delimiters;

public class TruncateDivideEqualsDelimiterToken extends DelimiterToken {
  public static final TruncateDivideEqualsDelimiterToken instance = new TruncateDivideEqualsDelimiterToken();

  private TruncateDivideEqualsDelimiterToken() {
    super("//=");
  }
}
