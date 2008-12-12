package org.metasyntactic.automata.compiler.java.scanner.operators;

public class RightShiftEqualsOperatorToken extends OperatorToken {
  public final static RightShiftEqualsOperatorToken instance = new RightShiftEqualsOperatorToken();

  private RightShiftEqualsOperatorToken() {
    super(">>=");
  }

  protected Type getTokenType() {
    return Type.RightShiftEqualsOperator;
  }
}
