package org.metasyntactic.automata.compiler.java.scanner.separators;

public class DotSeparatorToken extends SeparatorToken {
  public final static DotSeparatorToken instance = new DotSeparatorToken();

  private DotSeparatorToken() {
    super(".");
  }

  protected Type getTokenType() {
    return Type.DotSeparator;
  }
}
