package org.metasyntactic.automata.compiler.java.scanner.operators;

public class ModulusOperatorToken extends OperatorToken {
  public final static ModulusOperatorToken instance = new ModulusOperatorToken();

  private ModulusOperatorToken() {
    super("%");
  }

  protected Type getTokenType() {
    return Type.ModulusOperator;
  }
}
