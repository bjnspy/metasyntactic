package org.metasyntactic.automata.compiler.java.scanner;

public class WhitespaceToken extends JavaToken {
  public WhitespaceToken(String text) {
    super(text);
  }

   protected Type getTokenType() {
    return Type.Whitespace;
  }
}