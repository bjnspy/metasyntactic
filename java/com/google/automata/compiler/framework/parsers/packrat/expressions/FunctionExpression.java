// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers.packrat.expressions;

import com.google.automata.compiler.framework.parsers.packrat.EvaluationResult;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class FunctionExpression<T> extends Expression {
  private final String name;

  public FunctionExpression(String name) {
    this.name = name;
  }

  public abstract EvaluationResult apply(T input, int position);

  @Override public <TInput,TResult> TResult accept(ExpressionVisitor<TInput,TResult> visitor) {
    return visitor.visit((FunctionExpression<TInput>)this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit((FunctionExpression<TInput>)this);
  }

  public abstract boolean isNullable();

  public String getName() {
    return name;
  }

  @Override protected int hashCodeWorker() {
    return System.identityHashCode(this);
  }
}
