// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

import java.util.Arrays;
import java.util.List;

/**
 * Represents the ordered choice e_1 / e_2 / ... / e_n of several possible subexpressions.
 * <p/>
 * <p>The choice operator e1 / e2 first invokes e1, and if e1 succeeds, returns its result immediately. Otherwise, if e1
 * fails, then the choice operator backtracks to the original input position at which it invoked e1, but then calls e2
 * instead, returning e2's result.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class ChoiceExpression extends Expression {
  private final Expression[] children;

  ChoiceExpression(List<Expression> children) {
    this((Expression[]) children.toArray());
  }

  public ChoiceExpression(Expression... children) {
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
    if (!(o instanceof ChoiceExpression)) {
      return false;
    }

    ChoiceExpression that = (ChoiceExpression) o;

    return Arrays.equals(children, that.children);
  }

  @Override public int hashCodeWorker() {
    return Arrays.hashCode(children);
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public void accept(ExpressionVoidVisitor visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    StringBuilder builder = new StringBuilder();

    builder.append("(Choice");
    for (Expression child : getChildren()) {
      builder.append(' ');
      builder.append(child.toString());
    }
    builder.append(")");

    return builder.toString();
  }
}