// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class DelimitedSequenceExpression extends Expression {
  private final Expression element;
  private final Expression delimiter;
  private final boolean allowsTrailingDelimiter;

  public DelimitedSequenceExpression(Expression element, Expression delimiter) {
    this(element, delimiter, false);
  }

  public DelimitedSequenceExpression(Expression element, Expression delimiter,
      boolean allowsTrailingDelimiter) {
    this.element = element;
    this.delimiter = delimiter;
    this.allowsTrailingDelimiter = allowsTrailingDelimiter;
  }

  public Expression getElement() {
    return element;
  }

  public Expression getDelimiter() {
    return delimiter;
  }

  public boolean allowsTrailingDelimiter() {
    return allowsTrailingDelimiter;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof DelimitedSequenceExpression)) {
      return false;
    }

    DelimitedSequenceExpression that = (DelimitedSequenceExpression) o;

    if (allowsTrailingDelimiter != that.allowsTrailingDelimiter) {
      return false;
    }
    if (!delimiter.equals(that.delimiter)) {
      return false;
    }
    if (!element.equals(that.element)) {
      return false;
    }

    return true;
  }

  @Override protected int hashCodeWorker() {
    int result = super.hashCode();
    result = 31 * result + element.hashCode();
    result = 31 * result + delimiter.hashCode();
    result = 31 * result + (allowsTrailingDelimiter ? 1 : 0);
    return result;
  }

  @Override public String toString() {
    StringBuilder builder = new StringBuilder("(DelimitedSequence");

    builder.append(" ");
    builder.append(element);
    builder.append(" ");
    builder.append(delimiter);
    if (allowsTrailingDelimiter) {
      builder.append(" ");
      builder.append(allowsTrailingDelimiter);
    }
    builder.append(")");

    return builder.toString();
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }
}