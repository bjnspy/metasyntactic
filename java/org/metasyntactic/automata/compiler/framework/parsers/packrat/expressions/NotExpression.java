// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

/**
 * The expression !e invokes the sub-expression e, and then succeeds if e fails and fails if e succeeds, but in either
 * case never consumes any input.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class NotExpression extends Expression {
  private final Expression child;

  NotExpression(Expression child) {
    Preconditions.checkNotNull(child);

    this.child = child;
  }

  public Expression getChild() {
    return child;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof NotExpression)) {
      return false;
    }

    NotExpression that = (NotExpression) o;

    if (!child.equals(that.child)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return child.hashCode();
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    return "(Not " + getChild() + ")";
  }
}
