package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

public interface ExpressionVoidVisitor<TInput> {
  void visit(EmptyExpression emptyExpression);

  void visit(CharacterExpression characterExpression);

  void visit(TerminalExpression terminalExpression);

  void visit(VariableExpression variableExpression);

  void visit(DelimitedSequenceExpression sequenceExpression);

  void visit(SequenceExpression sequenceExpression);

  void visit(ChoiceExpression choiceExpression);

  void visit(NotExpression notExpression);

  void visit(RepetitionExpression repetitionExpression);

  void visit(FunctionExpression<TInput> functionExpression);

  void visit(OneOrMoreExpression oneOrMoreExpression);

  void visit(OptionalExpression optionalExpression);

  void visit(TokenExpression tokenExpression);

  void visit(TypeExpression typeExpression);
}
