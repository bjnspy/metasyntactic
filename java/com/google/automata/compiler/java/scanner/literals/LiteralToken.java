package com.google.automata.compiler.java.scanner.literals;

import com.google.automata.compiler.java.scanner.JavaToken;

public abstract class LiteralToken<T> extends JavaToken {
  protected LiteralToken(String text) {
    super(text);
  }

  public abstract T getValue();

  @Override protected Type getTokenType() {
    return type();
  }

  public static int typeValue() {
    return type().ordinal();
  }

  private static Type type() {
    return Type.Literal;
  }
}
