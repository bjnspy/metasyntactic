package com.google.automata.compiler.python.scanner.operators;

public class EqualsEqualsOperatorToken extends OperatorToken {
  public static EqualsEqualsOperatorToken instance = new EqualsEqualsOperatorToken();

  private EqualsEqualsOperatorToken() {
    super("==");
  }
}
