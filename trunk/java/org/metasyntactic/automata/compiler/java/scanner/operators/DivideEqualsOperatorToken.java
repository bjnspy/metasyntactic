package org.metasyntactic.automata.compiler.java.scanner.operators;

public class DivideEqualsOperatorToken extends OperatorToken {
  public final static DivideEqualsOperatorToken instance = new DivideEqualsOperatorToken();

  private DivideEqualsOperatorToken() {
    super("/=");
  }

  protected Type getTokenType() {
    return Type.DivideEqualsOperator;
  }
}
