package com.google.automata.compiler.java.scanner.operators;

public class MinusEqualsOperatorToken extends OperatorToken {
  public final static MinusEqualsOperatorToken instance = new MinusEqualsOperatorToken();

  private MinusEqualsOperatorToken() {
    super("-=");
  }
}
