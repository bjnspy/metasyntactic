// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

/**
 * A visitor for {@link Expression}s
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public interface ExpressionVisitor<TInput, TResult> {
  TResult visit(EmptyExpression emptyExpression);
  TResult visit(CharacterExpression characterExpression);
  TResult visit(TerminalExpression terminalExpression);
  TResult visit(VariableExpression variableExpression);
  TResult visit(DelimitedSequenceExpression sequenceExpression);
  TResult visit(SequenceExpression sequenceExpression);
  TResult visit(ChoiceExpression choiceExpression);
  TResult visit(NotExpression notExpression);
  TResult visit(RepetitionExpression repetitionExpression);
  TResult visit(FunctionExpression<TInput> functionExpression);
  TResult visit(OneOrMoreExpression oneOrMoreExpression);
  TResult visit(TokenExpression tokenExpression);
  TResult visit(TypeExpression typeExpression);
}

