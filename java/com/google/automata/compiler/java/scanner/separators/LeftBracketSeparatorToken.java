package com.google.automata.compiler.java.scanner.separators;

public class LeftBracketSeparatorToken extends SeparatorToken {
  public final static LeftBracketSeparatorToken instance = new LeftBracketSeparatorToken();

  private LeftBracketSeparatorToken() {
    super("[");
  }
}
