// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

/**
 * The zero-or-more operator consumes zero or more consecutive repetitions of its sub-expression e.  Unlike in
 * context-free grammars and regular expressions, however, this operator always behave greedily, consuming as much input
 * as possible and never backtracking.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class RepetitionExpression extends Expression {
  private final Expression child;

  RepetitionExpression(Expression child) {
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
    if (!(o instanceof RepetitionExpression)) {
      return false;
    }

    RepetitionExpression that = (RepetitionExpression) o;

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
    return "(Repetition " + getChild() + ")";
  }
}
