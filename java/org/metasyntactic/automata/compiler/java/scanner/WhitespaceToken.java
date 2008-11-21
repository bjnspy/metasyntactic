package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;

public class WhitespaceToken extends JavaToken {
  public WhitespaceToken(String text) {
    super(text);
  }

  @Override protected Type getTokenType() {
    return Type.Whitespace;
  }

  public static final Token representative = new WhitespaceToken(" ");
}