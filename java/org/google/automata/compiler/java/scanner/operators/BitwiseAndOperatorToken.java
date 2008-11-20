package com.google.automata.compiler.java.scanner.operators;

public class BitwiseAndOperatorToken extends OperatorToken {
  public final static BitwiseAndOperatorToken instance = new BitwiseAndOperatorToken();

  private BitwiseAndOperatorToken() {
    super("&");
  }
}
