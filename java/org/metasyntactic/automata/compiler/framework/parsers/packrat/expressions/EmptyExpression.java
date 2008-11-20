// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

/**
 * An atomic parsing expression consisting of the empty string always trivially
 * succeeds without consuming any input.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class EmptyExpression extends Expression {
  static final EmptyExpression instance = new EmptyExpression();

  private EmptyExpression() {
  }

  @Override public <TInput,TResult> TResult accept(ExpressionVisitor<TInput,TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override protected int hashCodeWorker() {
    return System.identityHashCode(this);
  }

  @Override public String toString() {
    return "?";
  }
}
