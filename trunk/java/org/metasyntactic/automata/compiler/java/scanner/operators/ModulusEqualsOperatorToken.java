package org.metasyntactic.automata.compiler.java.scanner.operators;

public class ModulusEqualsOperatorToken extends OperatorToken {
  public final static ModulusEqualsOperatorToken instance = new ModulusEqualsOperatorToken();

  private ModulusEqualsOperatorToken() {
    super("%=");
  }
}
