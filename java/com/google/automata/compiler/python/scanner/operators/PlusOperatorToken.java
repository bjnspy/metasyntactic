package com.google.automata.compiler.python.scanner.operators;

public class PlusOperatorToken extends OperatorToken {
  public static PlusOperatorToken instance = new PlusOperatorToken();

  private PlusOperatorToken() {
    super("+");
  }
}
