package org.metasyntactic.automata.compiler.java.scanner.operators;

public class BitwiseRightShiftEqualsOperatorToken extends OperatorToken {
  public final static BitwiseRightShiftEqualsOperatorToken instance = new BitwiseRightShiftEqualsOperatorToken();

  private BitwiseRightShiftEqualsOperatorToken() {
    super(">>>=");
  }

  protected Type getTokenType() {
    return Type.BitwiseRightShiftEqualsOperator;
  }
}
