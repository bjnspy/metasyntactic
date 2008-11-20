package com.google.automata.compiler.python.scanner.operators;

public class BitwiseNotOperatorToken extends OperatorToken {
  public static BitwiseNotOperatorToken instance = new BitwiseNotOperatorToken();

  private BitwiseNotOperatorToken() {
    super("~");
  }
}
