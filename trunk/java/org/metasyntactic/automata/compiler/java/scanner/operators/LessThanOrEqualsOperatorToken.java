package org.metasyntactic.automata.compiler.java.scanner.operators;

public class LessThanOrEqualsOperatorToken extends OperatorToken {
  public final static LessThanOrEqualsOperatorToken instance = new LessThanOrEqualsOperatorToken();

  private LessThanOrEqualsOperatorToken() {
    super("<=");
  }

  protected Type getTokenType() {
    return Type.LessThanOrEqualsOperator;
  }
}
