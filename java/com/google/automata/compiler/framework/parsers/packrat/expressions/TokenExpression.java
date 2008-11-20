package com.google.automata.compiler.framework.parsers.packrat.expressions;

import com.google.automata.compiler.framework.parsers.Token;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TokenExpression extends Expression {
  private final Token token;

  public TokenExpression(Token token) {
    this.token = token;
  }

  public Token getToken() {
    return token;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    TokenExpression that = (TokenExpression) o;

    if (!token.equals(that.token)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return token.hashCode();
  }

  @Override public <TInput,TResult> TResult accept(ExpressionVisitor<TInput,TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    return token.toString();
  }
}
