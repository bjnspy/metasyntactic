package org.metasyntactic.automata.compiler.java.scanner.operators;

public class MinusOperatorToken extends OperatorToken {
  public final static MinusOperatorToken instance = new MinusOperatorToken();

  private MinusOperatorToken() {
    super("-");
  }

  protected Type getTokenType() {
    return Type.MinusOperator;
  }
}
