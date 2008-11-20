package com.google.automata.compiler.python.scanner;

import com.google.automata.compiler.framework.parsers.Token;
import com.google.common.base.Preconditions;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 2:00:29 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class PythonToken implements Token {
  private final String text;

  public PythonToken(String text) {
    Preconditions.checkNotNull(text);
    this.text = text;
  }

  @Override public String getText() {
    return text;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    PythonToken that = (PythonToken) o;

    if (!text.equals(that.text)) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    return text.hashCode();
  }

  @Override public String toString() {
    return getText();
  }

  @Override public int getType() {
    return getTokenType().ordinal();
  }

  public abstract Type getTokenType();

  public static enum Type {
    Delimiter,
    Keyword,
    Literal,
    Operator,
    Comment,
    Dedent,
    Error,
    Identifier,
    Indent,
    LineContinuation,
    Newline,
    Whitespace
  }
}