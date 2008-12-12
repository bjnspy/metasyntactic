package org.metasyntactic.automata.compiler.java.scanner.operators;

public class PlusEqualsOperatorToken extends OperatorToken {
  public final static PlusEqualsOperatorToken instance = new PlusEqualsOperatorToken();

  private PlusEqualsOperatorToken() {
    super("+=");
  }

  protected Type getTokenType() {
    return Type.PlusEqualsOperator;
  }
}
