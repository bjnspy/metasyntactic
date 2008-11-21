package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.java.scanner.keywords.KeywordToken;
import org.metasyntactic.automata.compiler.java.scanner.literals.LiteralToken;
import org.metasyntactic.automata.compiler.java.scanner.operators.OperatorToken;
import org.metasyntactic.automata.compiler.java.scanner.separators.SeparatorToken;
import org.metasyntactic.common.base.Preconditions;

import java.util.Collection;
import java.util.LinkedHashSet;

public abstract class JavaToken implements Token {
  private final String text;

  private static Collection<Class> tokenClasses;

  public static Collection<Class> tokenClasses() {
    if (tokenClasses == null) {
      tokenClasses = new LinkedHashSet<Class>();

      tokenClasses.addAll(KeywordToken.tokenClasses());
      tokenClasses.addAll(OperatorToken.tokenClasses());
      tokenClasses.addAll(SeparatorToken.tokenClasses());
      tokenClasses.add(CommentToken.class);
      tokenClasses.add(IdentifierToken.class);
      tokenClasses.add(WhitespaceToken.class);
    }

    return tokenClasses;
  }

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

  public Class<? extends Token> getRepresentativeClass() {
    switch (getTokenType()) {
      case Comment:
        return CommentToken.class;
      case Error:
        return ErrorToken.class;
      case Identifier:
        return IdentifierToken.class;
      case Keyword:
        return KeywordToken.class;
      case Literal:
        return LiteralToken.class;
      case Operator:
        return OperatorToken.class;
      case Separator:
        return SeparatorToken.class;
      case Whitespace:
        return WhitespaceToken.class;
    }

    throw new IllegalStateException();
  }
}
