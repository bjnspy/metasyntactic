package org.metasyntactic.automata.compiler.python.scanner;

public class IdentifierToken extends PythonToken {
  public IdentifierToken(String text) {
    super(text);
  }

  public Type getTokenType() {
    return Type.Identifier;
  }

  public static int typeValue() {
    return type().ordinal();
  }

  private static Type type() {
    return Type.Identifier;
  }
}
