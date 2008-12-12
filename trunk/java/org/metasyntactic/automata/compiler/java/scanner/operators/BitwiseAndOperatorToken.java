package org.metasyntactic.automata.compiler.java.scanner.operators;

public class BitwiseAndOperatorToken extends OperatorToken {
  public final static BitwiseAndOperatorToken instance = new BitwiseAndOperatorToken();

  private BitwiseAndOperatorToken() {
    super("&");
  }

  protected Type getTokenType() {
    return Type.BitwiseAndOperator;
  }
}
