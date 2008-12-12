package org.metasyntactic.automata.compiler.java.scanner.operators;

public class QuestionMarkOperatorToken extends OperatorToken {
  public final static QuestionMarkOperatorToken instance = new QuestionMarkOperatorToken();

  private QuestionMarkOperatorToken() {
    super("?");
  }

  protected Type getTokenType() {
    return Type.QuestionMarkOperator;
  }
}
