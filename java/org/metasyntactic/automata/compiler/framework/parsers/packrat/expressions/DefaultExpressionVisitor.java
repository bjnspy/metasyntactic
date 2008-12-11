// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

public class DefaultExpressionVisitor<TInput, TResult> implements ExpressionVisitor<TInput, TResult> {
  protected TResult defaultCase(Expression expression) {
    return null;
  }

   public TResult visit(EmptyExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(CharacterExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(TerminalExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(VariableExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(DelimitedSequenceExpression sequenceExpression) {
    return defaultCase(sequenceExpression);
  }

   public TResult visit(SequenceExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(ChoiceExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(OptionalExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(NotExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(RepetitionExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(FunctionExpression<TInput> expression) {
    return defaultCase(expression);
  }

   public TResult visit(OneOrMoreExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(TokenExpression expression) {
    return defaultCase(expression);
  }

   public TResult visit(TypeExpression expression) {
    return defaultCase(expression);
  }
}
