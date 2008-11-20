package com.google.automata.compiler.java.scanner;

import com.google.automata.compiler.framework.parsers.Token;
import com.google.common.base.Preconditions;

public abstract class JavaToken implements Token {
  private final String text;

  protected JavaToken(String text) {
    Preconditions.checkNotNull(text);
    this.text = text;
  }

  @Override public String getText() {
    return text;
  }

  @Override public String toString() {
    return getText();
  }

  @Override public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;

    JavaToken javaToken = (JavaToken) o;

    if (!text.equals(javaToken.text)) return false;

    return true;
  }

  @Override public int hashCode() {
    return text.hashCode();
  }

  @Override public int getType() {
    return getTokenType().ordinal();
  }

  protected abstract Type getTokenType();

  public static enum Type {
    Keyword,
    Literal,
    Operator,
    Separator,
    Comment,
    Error,
    Identifier,
    Whitespace
  }
}
