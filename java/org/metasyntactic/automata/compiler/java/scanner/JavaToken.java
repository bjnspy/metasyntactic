package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.common.base.Preconditions;

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
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    JavaToken javaToken = (JavaToken) o;

    if (!text.equals(javaToken.text)) {
      return false;
    }

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
    Identifier,
    Keyword,
    Literal,
    Operator,
    Separator,
    Comment,
    Error,
    Whitespace
  }

  public int compareTo(Token token) {
    int value = getType() - token.getType();
    if (value != 0) {
      return value;
    }

    String text1 = getText();
    String text2 = token.getText();

    value = text1.length() - text2.length();
    if (value != 0) {
      return value;
    }

    return text1.compareTo(text2);
  }
}
