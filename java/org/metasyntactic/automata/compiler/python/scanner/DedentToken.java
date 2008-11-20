package com.google.automata.compiler.python.scanner;

public class DedentToken extends PythonToken {
  public static final DedentToken instance = new DedentToken();

  private DedentToken() {
    super("");
  }

  @Override public Type getTokenType() {
    return Type.Dedent;
  }

  @Override public String toString() {
    return "Dedent";
  }
}
