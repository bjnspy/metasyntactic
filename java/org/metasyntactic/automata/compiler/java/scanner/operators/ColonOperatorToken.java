package org.metasyntactic.automata.compiler.java.scanner.operators;

public class ColonOperatorToken extends OperatorToken {
  public final static ColonOperatorToken instance = new ColonOperatorToken();

  private ColonOperatorToken() {
    super(":");
  }

  protected Type getTokenType() {
    return Type.ColonOperator;
  }
}
