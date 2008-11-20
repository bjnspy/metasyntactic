package com.google.automata.compiler.java.scanner.operators;

public class LeftShiftEqualsOperatorToken extends OperatorToken {
  public final static LeftShiftEqualsOperatorToken instance = new LeftShiftEqualsOperatorToken();

  private LeftShiftEqualsOperatorToken() {
    super("<<=");
  }
}
