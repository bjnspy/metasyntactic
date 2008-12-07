// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

import java.util.Arrays;
import java.util.List;

/**
 * Represents the sequence e_1 e_2 ... e_n of several possible subexpressions.
 * <p/>
 * <p>The sequence operator e1 e2 first invokes e1, and if e1 succeeds, subsequently invokes e2 on the remainder of the
 * input string left unconsumed by e1, and returns the result. If either e1 or e2 fails, then the sequence expression e1
 * e2 fails.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class SequenceExpression extends Expression {
  private final Expression[] children;

  SequenceExpression(List<Expression> children) {
    this(children.toArray(new Expression[children.size()]));
  }

  SequenceExpression(Expression... children) {
    Preconditions.checkArgument(children.length >= 2);

    this.children = children;
  }

  public Expression[] getChildren() {
    return children;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof SequenceExpression)) {
      return false;
    }

    SequenceExpression that = (SequenceExpression) o;

    if (!Arrays.equals(children, that.children)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return Arrays.hashCode(children);
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    StringBuilder builder = new StringBuilder("(Sequence");

    for (Expression child : getChildren()) {
      builder.append(' ');
      builder.append(child);
    }

    builder.append(')');

    return builder.toString();
  }
}
