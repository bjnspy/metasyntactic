package org.metasyntactic.automata.compiler.java.scanner.operators;

public class NotEqualsOperatorToken extends OperatorToken {
  public final static NotEqualsOperatorToken instance = new NotEqualsOperatorToken();

  private NotEqualsOperatorToken() {
    super("!=");
  }
}
