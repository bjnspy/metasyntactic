package com.google.automata.compiler.python.scanner;

public class LineContinuationToken extends PythonToken {
  public static final LineContinuationToken instance = new LineContinuationToken();

  private LineContinuationToken() {
    super("\\");
  }

  @Override public Type getTokenType() {
    return Type.LineContinuation;
  }
}