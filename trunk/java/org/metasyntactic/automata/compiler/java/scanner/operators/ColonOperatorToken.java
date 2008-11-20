package com.google.automata.compiler.java.scanner.operators;

public class ColonOperatorToken extends OperatorToken {
  public final static ColonOperatorToken instance = new ColonOperatorToken();

  private ColonOperatorToken() {
    super(":");
  }
}
