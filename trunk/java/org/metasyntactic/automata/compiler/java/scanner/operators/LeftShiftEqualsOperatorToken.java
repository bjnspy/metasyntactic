package org.metasyntactic.automata.compiler.java.scanner.operators;

public class LeftShiftEqualsOperatorToken extends OperatorToken {
  public final static LeftShiftEqualsOperatorToken instance = new LeftShiftEqualsOperatorToken();

  private LeftShiftEqualsOperatorToken() {
    super("<<=");
  }

  protected Type getTokenType() {
    return Type.LeftShiftEqualsOperator;
  }
}
