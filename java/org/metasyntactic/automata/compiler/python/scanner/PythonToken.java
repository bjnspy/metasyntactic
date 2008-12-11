package org.metasyntactic.automata.compiler.python.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.common.base.Preconditions;

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

   public String getText() {
    return text;
  }

   public boolean equals(Object o) {
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

   public int hashCode() {
    return text.hashCode();
  }

   public String toString() {
    return getText();
  }

   public int getType() {
    return getTokenType().ordinal();
  }

  public abstract Type getTokenType();

  public static enum Type {
    Identifier,
    Delimiter,
    Keyword,
    Literal,
    Operator,
    Comment,
    Dedent,
    Error,
    Indent,
    LineContinuation,
    Newline,
    Whitespace
  }

  public int compareTo(Token token) {
    return getType() - token.getType();
  }
}