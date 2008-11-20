package org.metasyntactic.automata.compiler.python.scanner.operators;

public class LessThanOrEqualsOperatorToken extends OperatorToken {
  public static LessThanOrEqualsOperatorToken instance = new LessThanOrEqualsOperatorToken();

  private LessThanOrEqualsOperatorToken() {
    super("<=");
  }
}
