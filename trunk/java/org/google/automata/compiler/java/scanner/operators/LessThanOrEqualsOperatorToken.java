package com.google.automata.compiler.java.scanner.operators;

public class LessThanOrEqualsOperatorToken extends OperatorToken {
  public final static LessThanOrEqualsOperatorToken instance = new LessThanOrEqualsOperatorToken();

  private LessThanOrEqualsOperatorToken() {
    super("<=");
  }
}
