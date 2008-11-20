package com.google.automata.compiler.java.scanner.separators;

public class LeftParenthesisSeparatorToken extends SeparatorToken {
  public final static LeftParenthesisSeparatorToken instance = new LeftParenthesisSeparatorToken();

  private LeftParenthesisSeparatorToken() {
    super("(");
  }
}
