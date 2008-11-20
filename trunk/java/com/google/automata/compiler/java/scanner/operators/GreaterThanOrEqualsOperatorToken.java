package com.google.automata.compiler.java.scanner.operators;

public class GreaterThanOrEqualsOperatorToken extends OperatorToken {
  public final static GreaterThanOrEqualsOperatorToken instance = new GreaterThanOrEqualsOperatorToken();

  private GreaterThanOrEqualsOperatorToken() {
    super(">=");
  }
}
