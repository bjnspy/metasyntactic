package com.google.automata.compiler.python.scanner.operators;

public class GreaterThanOrEqualsOperatorToken extends OperatorToken {
  public static GreaterThanOrEqualsOperatorToken instance = new GreaterThanOrEqualsOperatorToken();

  private GreaterThanOrEqualsOperatorToken() {
    super(">=");
  }
}
