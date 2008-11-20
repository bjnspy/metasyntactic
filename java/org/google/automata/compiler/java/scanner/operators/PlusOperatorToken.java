package com.google.automata.compiler.java.scanner.operators;

public class PlusOperatorToken extends OperatorToken {
  public final static PlusOperatorToken instance = new PlusOperatorToken();

  private PlusOperatorToken() {
    super("+");
  }
}
