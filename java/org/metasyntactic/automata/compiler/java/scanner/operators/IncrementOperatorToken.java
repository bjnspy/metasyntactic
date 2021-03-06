package org.metasyntactic.automata.compiler.java.scanner.operators;

public class IncrementOperatorToken extends OperatorToken {
  public final static IncrementOperatorToken instance = new IncrementOperatorToken();

  private IncrementOperatorToken() {
    super("++");
  }

  protected Type getTokenType() {
    return Type.IncrementOperator;
  }
}
