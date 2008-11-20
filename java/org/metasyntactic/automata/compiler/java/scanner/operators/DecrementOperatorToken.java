package org.metasyntactic.automata.compiler.java.scanner.operators;

public class DecrementOperatorToken extends OperatorToken {
  public final static DecrementOperatorToken instance = new DecrementOperatorToken();

  private DecrementOperatorToken() {
    super("--");
  }
}
