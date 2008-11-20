package com.google.automata.compiler.java.scanner.operators;

public class EqualsOperatorToken extends OperatorToken {
  public final static EqualsOperatorToken instance = new EqualsOperatorToken();

  private EqualsOperatorToken() {
    super("=");
  }
}
