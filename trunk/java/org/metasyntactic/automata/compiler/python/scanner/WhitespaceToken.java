package org.metasyntactic.automata.compiler.python.scanner;

public class WhitespaceToken extends PythonToken {
  public WhitespaceToken(String text) {
    super(text);
  }

   public Type getTokenType() {
    return Type.Whitespace;
  }
}
