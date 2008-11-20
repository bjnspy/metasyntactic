package com.google.automata.compiler.python.scanner.operators;

public class MinusOperatorToken extends OperatorToken {
  public static MinusOperatorToken instance = new MinusOperatorToken();

  private MinusOperatorToken() {
    super("-");
  }
}
