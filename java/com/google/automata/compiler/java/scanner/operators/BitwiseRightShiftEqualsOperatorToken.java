package com.google.automata.compiler.java.scanner.operators;

public class BitwiseRightShiftEqualsOperatorToken extends OperatorToken {
  public final static BitwiseRightShiftEqualsOperatorToken instance = new BitwiseRightShiftEqualsOperatorToken();

  private BitwiseRightShiftEqualsOperatorToken() {
    super(">>>=");
  }
}
