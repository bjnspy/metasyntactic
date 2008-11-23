package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 20, 2008 Time: 5:42:01 PM To change this template use File |
 * Settings | File Templates.
 */
public class RecursionExpressionVisitor implements ExpressionVoidVisitor {
  @Override public void visit(EmptyExpression emptyExpression) { }

  @Override public void visit(CharacterExpression characterExpression) { }

  @Override public void visit(TerminalExpression terminalExpression) { }

  @Override public void visit(VariableExpression variableExpression) { }

  @Override public void visit(FunctionExpression functionExpression) { }

  @Override public void visit(TokenExpression tokenExpression) { }

  @Override public void visit(TypeExpression typeExpression) { }

  @Override public void visit(DelimitedSequenceExpression sequenceExpression) {
    sequenceExpression.getElement().accept(this);
    sequenceExpression.getDelimiter().accept(this);
  }

  @Override public void visit(SequenceExpression sequenceExpression) {
    for (Expression child : sequenceExpression.getChildren()) {
      child.accept(this);
    }
  }

  @Override public void visit(OneOrMoreExpression oneOrMoreExpression) {
    oneOrMoreExpression.getChild().accept(this);
  }

  @Override public void visit(ChoiceExpression choiceExpression) {
    for (Expression child : choiceExpression.getChildren()) {
      child.accept(this);
    }
  }

  @Override public void visit(NotExpression notExpression) {
    notExpression.getChild().accept(this);
  }

  @Override public void visit(RepetitionExpression repetitionExpression) {
    repetitionExpression.getChild().accept(this);
  }
}
