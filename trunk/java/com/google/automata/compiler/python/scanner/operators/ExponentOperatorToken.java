package com.google.automata.compiler.python.scanner.operators;

public class ExponentOperatorToken extends OperatorToken {
  public static ExponentOperatorToken instance = new ExponentOperatorToken();

  private ExponentOperatorToken() {
    super("**");
  }
}
