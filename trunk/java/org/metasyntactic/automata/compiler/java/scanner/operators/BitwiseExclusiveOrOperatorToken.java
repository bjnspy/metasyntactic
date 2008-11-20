package org.metasyntactic.automata.compiler.java.scanner.operators;

public class BitwiseExclusiveOrOperatorToken extends OperatorToken {
  public final static BitwiseExclusiveOrOperatorToken instance = new BitwiseExclusiveOrOperatorToken();

  private BitwiseExclusiveOrOperatorToken() {
    super("^");
  }
}
