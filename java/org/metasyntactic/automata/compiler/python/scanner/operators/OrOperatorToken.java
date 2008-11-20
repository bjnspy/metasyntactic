package com.google.automata.compiler.python.scanner.operators;

public class OrOperatorToken extends OperatorToken {
  public static OrOperatorToken instance = new OrOperatorToken();

  private OrOperatorToken() {
    super("|");
  }
}
