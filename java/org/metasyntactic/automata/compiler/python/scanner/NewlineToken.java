package org.metasyntactic.automata.compiler.python.scanner;

public class NewlineToken extends PythonToken {
  public NewlineToken(String text) {
    super(text);
  }

  @Override public Type getTokenType() {
    return Type.Newline;
  }

  public static int typeValue() {
    return type().ordinal();
  }

  private static Type type() {
    return Type.Newline;
  }
}
