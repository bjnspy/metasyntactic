package com.google.automata.compiler.java.scanner.operators;

public class GreaterThanOperatorToken extends OperatorToken {
  public final static GreaterThanOperatorToken instance = new GreaterThanOperatorToken();

  private GreaterThanOperatorToken() {
    super(">");
  }
}
