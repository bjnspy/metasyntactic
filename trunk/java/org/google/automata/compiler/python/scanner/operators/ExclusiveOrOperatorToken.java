package com.google.automata.compiler.python.scanner.operators;

public class ExclusiveOrOperatorToken extends OperatorToken {
  public static ExclusiveOrOperatorToken instance = new ExclusiveOrOperatorToken();

  private ExclusiveOrOperatorToken() {
    super("^");
  }
}
