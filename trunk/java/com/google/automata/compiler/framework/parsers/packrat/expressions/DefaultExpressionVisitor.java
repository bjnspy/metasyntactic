// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers.packrat.expressions;

public class DefaultExpressionVisitor<TInput,TResult> implements ExpressionVisitor<TInput, TResult> {
  protected TResult defaultCase(Expression expression) {
      return null;
  }

  @Override public TResult visit(EmptyExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(CharacterExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(TerminalExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(VariableExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(DelimitedSequenceExpression sequenceExpression) {
    return defaultCase(sequenceExpression);
  }

  @Override public TResult visit(SequenceExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(ChoiceExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(NotExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(RepetitionExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(FunctionExpression<TInput> expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(OneOrMoreExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(TokenExpression expression) {
    return defaultCase(expression);
  }

  @Override public TResult visit(TypeExpression expression) {
    return defaultCase(expression);
  }
}
