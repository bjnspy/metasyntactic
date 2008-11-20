package org.metasyntactic.automata.compiler.java.scanner.operators;

public class BitwiseNotOperatorToken extends OperatorToken {
  public final static BitwiseNotOperatorToken instance = new BitwiseNotOperatorToken();

  private BitwiseNotOperatorToken() {
    super("~");
  }
}
