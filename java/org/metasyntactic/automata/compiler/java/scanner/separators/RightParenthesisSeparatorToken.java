package com.google.automata.compiler.java.scanner.separators;

public class RightParenthesisSeparatorToken extends SeparatorToken {
  public final static RightParenthesisSeparatorToken instance = new RightParenthesisSeparatorToken();

  private RightParenthesisSeparatorToken() {
    super(")");
  }
}
