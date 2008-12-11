package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.automata.compiler.framework.parsers.Token;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TokenExpression extends Expression {
  private final Token token;

  public TokenExpression(Token token) {
    this.token = token;
  }

  public Token getToken() {
    return token;
  }

   public boolean equals(Object o) {
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

   public int hashCodeWorker() {
    return token.hashCode();
  }

   public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

   public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

   public String toString() {
    return token.toString();
  }
}
