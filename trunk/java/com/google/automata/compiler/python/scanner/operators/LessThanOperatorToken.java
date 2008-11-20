package com.google.automata.compiler.python.scanner.operators;

public class LessThanOperatorToken extends OperatorToken {
  public static LessThanOperatorToken instance = new LessThanOperatorToken();

  private LessThanOperatorToken() {
    super("<");
  }
}
