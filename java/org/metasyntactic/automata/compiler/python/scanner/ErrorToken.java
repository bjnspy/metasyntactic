package org.metasyntactic.automata.compiler.python.scanner;

public class ErrorToken extends PythonToken {
  public ErrorToken(String text) {
    super(text);
  }

   public Type getTokenType() {
    return Type.Error;
  }
}