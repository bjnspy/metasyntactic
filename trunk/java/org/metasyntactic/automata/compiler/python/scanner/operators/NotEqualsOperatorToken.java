package org.metasyntactic.automata.compiler.python.scanner.operators;

public class NotEqualsOperatorToken extends OperatorToken {
  public static NotEqualsOperatorToken instance = new NotEqualsOperatorToken();

  private NotEqualsOperatorToken() {
    super("!=");
  }
}
