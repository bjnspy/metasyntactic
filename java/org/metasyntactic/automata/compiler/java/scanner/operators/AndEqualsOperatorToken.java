package org.metasyntactic.automata.compiler.java.scanner.operators;

public class AndEqualsOperatorToken extends OperatorToken {
  public final static AndEqualsOperatorToken instance = new AndEqualsOperatorToken();

  private AndEqualsOperatorToken() {
    super("&=");
  }

  protected Type getTokenType() {
    return Type.AndEqualsOperator;
  }
}
