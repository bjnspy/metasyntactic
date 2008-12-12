package org.metasyntactic.automata.compiler.java.scanner.operators;

public class GreaterThanOrEqualsOperatorToken extends OperatorToken {
  public final static GreaterThanOrEqualsOperatorToken instance = new GreaterThanOrEqualsOperatorToken();

  private GreaterThanOrEqualsOperatorToken() {
    super(">=");
  }

  protected Type getTokenType() {
    return Type.GreaterThanOrEqualsOperator;
  }
}
