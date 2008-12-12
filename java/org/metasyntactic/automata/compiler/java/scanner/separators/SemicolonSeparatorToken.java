package org.metasyntactic.automata.compiler.java.scanner.separators;

public class SemicolonSeparatorToken extends SeparatorToken {
  public final static SemicolonSeparatorToken instance = new SemicolonSeparatorToken();

  private SemicolonSeparatorToken() {
    super(";");
  }

  protected Type getTokenType() {
    return Type.SemicolonSeparator;
  }
}