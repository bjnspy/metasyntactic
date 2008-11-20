package org.metasyntactic.automata.compiler.python.scanner.operators;

public class LessThanGreaterThanOperatorToken extends OperatorToken {
  public static LessThanGreaterThanOperatorToken instance = new LessThanGreaterThanOperatorToken();

  private LessThanGreaterThanOperatorToken() {
    super("<>");
  }
}
