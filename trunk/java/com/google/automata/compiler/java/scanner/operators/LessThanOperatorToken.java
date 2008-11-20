package com.google.automata.compiler.java.scanner.operators;

public class LessThanOperatorToken extends OperatorToken {
  public final static LessThanOperatorToken instance = new LessThanOperatorToken();

  private LessThanOperatorToken() {
    super("<");
  }
}
