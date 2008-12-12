package org.metasyntactic.automata.compiler.java.scanner.operators;

public class DivideOperatorToken extends OperatorToken {
  public final static DivideOperatorToken instance = new DivideOperatorToken();

  private DivideOperatorToken() {
    super("/");
  }

  protected Type getTokenType() {
    return Type.DivideOperator;
  }
}
