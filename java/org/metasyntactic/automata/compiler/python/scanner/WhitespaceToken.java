package com.google.automata.compiler.python.scanner;

public class WhitespaceToken extends PythonToken {
  public WhitespaceToken(String text) {
    super(text);
  }

  @Override public Type getTokenType() {
    return Type.Whitespace;
  }
}
