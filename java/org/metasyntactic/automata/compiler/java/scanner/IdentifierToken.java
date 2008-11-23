package org.metasyntactic.automata.compiler.java.scanner;

public class IdentifierToken extends JavaToken {
  public IdentifierToken(String text) {
    super(text);
  }

  @Override protected Type getTokenType() {
    return type();
  }

  public static int getTypeValue() {
    return type().ordinal();
  }

  public static Type type() {
    return Type.Identifier;
  }
}
