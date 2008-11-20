package com.google.automata.compiler.java.scanner.operators;

public class MinusOperatorToken extends OperatorToken {
  public final static MinusOperatorToken instance = new MinusOperatorToken();

  private MinusOperatorToken() {
    super("-");
  }
}
