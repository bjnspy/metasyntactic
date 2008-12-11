package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 20, 2008 Time: 5:42:01 PM To change this template use File |
 * Settings | File Templates.
 */
public class RecursionExpressionVisitor implements ExpressionVoidVisitor {
   public void visit(EmptyExpression emptyExpression) { }

   public void visit(CharacterExpression characterExpression) { }

   public void visit(TerminalExpression terminalExpression) { }

   public void visit(VariableExpression variableExpression) { }

   public void visit(FunctionExpression functionExpression) { }

   public void visit(TokenExpression tokenExpression) { }

   public void visit(TypeExpression typeExpression) { }

   public void visit(DelimitedSequenceExpression sequenceExpression) {
    sequenceExpression.getElement().accept(this);
    sequenceExpression.getDelimiter().accept(this);
  }

   public void visit(SequenceExpression sequenceExpression) {
    for (Expression child : sequenceExpression.getChildren()) {
      child.accept(this);
    }
  }

   public void visit(OneOrMoreExpression oneOrMoreExpression) {
    oneOrMoreExpression.getChild().accept(this);
  }

   public void visit(ChoiceExpression choiceExpression) {
    for (Expression child : choiceExpression.getChildren()) {
      child.accept(this);
    }
  }

   public void visit(OptionalExpression optionalExpression) {
    optionalExpression.getChild().accept(this);
  }

   public void visit(NotExpression notExpression) {
    notExpression.getChild().accept(this);
  }

   public void visit(RepetitionExpression repetitionExpression) {
    repetitionExpression.getChild().accept(this);
  }
}
