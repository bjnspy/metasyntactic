package com.google.automata.compiler.python.scanner.operators;

public class GreaterThanOperatorToken extends OperatorToken {
  public static GreaterThanOperatorToken instance = new GreaterThanOperatorToken();

  private GreaterThanOperatorToken() {
    super(">");
  }
}
