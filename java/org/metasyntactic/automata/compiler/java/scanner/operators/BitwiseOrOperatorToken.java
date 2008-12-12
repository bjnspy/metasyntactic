package org.metasyntactic.automata.compiler.java.scanner.operators;

public class BitwiseOrOperatorToken extends OperatorToken {
  public final static BitwiseOrOperatorToken instance = new BitwiseOrOperatorToken();

  private BitwiseOrOperatorToken() {
    super("|");
  }

  protected Type getTokenType() {
    return Type.BitwiseOrOperator;
  }
}
