package org.metasyntactic.automata.compiler.java.scanner.separators;

public class RightBracketSeparatorToken extends SeparatorToken {
  public final static RightBracketSeparatorToken instance = new RightBracketSeparatorToken();

  private RightBracketSeparatorToken() {
    super("]");
  }
}
