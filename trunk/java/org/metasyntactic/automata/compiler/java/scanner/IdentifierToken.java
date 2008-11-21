package org.metasyntactic.automata.compiler.java.scanner;

public class IdentifierToken extends JavaToken {
  public IdentifierToken(String text) {
    super(text);
  }

  @Override protected Type getTokenType() {
    return type();
  }

  public static int typeValue() {
    return type().ordinal();
  }

  private static Type type() {
    return Type.Identifier;
  }

  public static final IdentifierToken representative = new IdentifierToken("identifier");
}
