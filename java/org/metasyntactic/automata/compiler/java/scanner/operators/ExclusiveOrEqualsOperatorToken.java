package org.metasyntactic.automata.compiler.java.scanner.operators;

public class ExclusiveOrEqualsOperatorToken extends OperatorToken {
  public final static ExclusiveOrEqualsOperatorToken instance = new ExclusiveOrEqualsOperatorToken();

  private ExclusiveOrEqualsOperatorToken() {
    super("^=");
  }
}
