package com.google.automata.compiler.java.scanner.operators;

public class PlusEqualsOperatorToken extends OperatorToken {
  public final static PlusEqualsOperatorToken instance = new PlusEqualsOperatorToken();

  private PlusEqualsOperatorToken() {
    super("+=");
  }
}
