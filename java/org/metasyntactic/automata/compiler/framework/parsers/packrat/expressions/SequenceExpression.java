// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.common.base.Preconditions;

import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

/**
 * Represents the sequence e_1 e_2 ... e_n of several possible subexpressions.
 * <p/>
 * <p>The sequence operator e1 e2 first invokes e1, and if e1 succeeds, subsequently invokes e2 on the remainder of the
 * input string left unconsumed by e1, and returns the result. If either e1 or e2 fails, then the sequence expression e1
 * e2 fails.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class SequenceExpression extends Expression {
  private final String[] childNames;
  private final Expression[] children;

  SequenceExpression(List<Expression> children) {
    this(children.toArray(new Expression[children.size()]));
  }

  SequenceExpression(Expression... children) {
    Preconditions.checkArgument(children.length >= 2);

    this.children = children;

    List<String> names = new ArrayList<String>();
    for (Expression child : children) {
      String name = child.accept(new DetermineNameVisitor());
      names.add(name);
    }

    childNames = names.toArray(new String[names.size()]);
  }

  public Expression[] getChildren() {
    return children;
  }

  public String[] getChildNames() {
    return childNames;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof SequenceExpression)) {
      return false;
    }

    SequenceExpression that = (SequenceExpression) o;

    if (!Arrays.equals(children, that.children)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return Arrays.hashCode(children);
  }

  @Override public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    StringBuilder builder = new StringBuilder("(Sequence");

    for (Expression child : getChildren()) {
      builder.append(' ');
      builder.append(child);
    }

    builder.append(')');

    return builder.toString();
  }

  private static String makeName(String s) {
    return s;
      //return s.substring(0, 1).toLowerCase() + s.substring(1);
  }

  private class DetermineNameVisitor implements ExpressionVisitor<Object,String> {
    public String visit(EmptyExpression emptyExpression) {
      throw new RuntimeException("NYI");
    }

    public String visit(CharacterExpression characterExpression) {
      throw new RuntimeException("NYI");
    }

    public String visit(TerminalExpression terminalExpression) {
      throw new RuntimeException("NYI");
    }

    public String visit(VariableExpression variableExpression) {
      return makeName(variableExpression.getVariable());
    }

    public String visit(DelimitedSequenceExpression sequenceExpression) {
      return sequenceExpression.getElement().accept(this) + "List";
    }

    public String visit(SequenceExpression sequenceExpression) {
      throw new RuntimeException("Bad grammar!");
    }

    public String visit(ChoiceExpression choiceExpression) {
      throw new RuntimeException("Bad grammar!");
    }

    public String visit(NotExpression notExpression) {
      return "";
    }

    public String visit(RepetitionExpression repetitionExpression) {
      return repetitionExpression.getChild().accept(this) + "List";
    }

    public String visit(FunctionExpression<Object> objectFunctionExpression) {
      throw new RuntimeException("Bad grammar!");
    }

    public String visit(OneOrMoreExpression oneOrMoreExpression) {
      return oneOrMoreExpression.getChild().accept(this) + "List";
    }

    public String visit(OptionalExpression optionalExpression) {
      return "Optional" + optionalExpression.getChild().accept(this);
    }

    public String visit(TokenExpression tokenExpression) {
      String s = tokenExpression.getToken().getClass().getSimpleName();
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }

    public String visit(TypeExpression typeExpression) {
      String s = typeExpression.getType().getSimpleName();
      if (s.endsWith("Token")) {
        s = s.substring(0, s.length() - "Token".length());
      }
      return makeName(s);
    }
  }
}
