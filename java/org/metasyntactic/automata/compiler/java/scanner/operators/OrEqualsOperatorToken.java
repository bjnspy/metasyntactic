package org.metasyntactic.automata.compiler.java.scanner.operators;

public class OrEqualsOperatorToken extends OperatorToken {
  public final static OrEqualsOperatorToken instance = new OrEqualsOperatorToken();

  private OrEqualsOperatorToken() {
    super("|=");
  }
}
