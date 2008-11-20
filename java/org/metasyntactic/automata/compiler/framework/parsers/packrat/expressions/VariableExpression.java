// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratGrammar;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.Rule;
import org.metasyntactic.common.base.Preconditions;

/**
 * Each nonterminal in a parsing expression grammar essentially represents a
 * parsing function in a recursive descent parser, and the corresponding parsing
 * expression represents the "code" comprising the function. Each parsing
 * function conceptually takes an input string as its argument, and yields one
 * of the following results:
 * <ul>
 *   <li>success, in which the function may optionally move forward or "consume"
 *       one or more characters of the input string supplied to it, or</li>
 *   <li>failure, in which case no input is consumed.</li>
 * </ul>
 *
 * <p> A nonterminal may succeed without actually consuming any input, and this
 * is considered an outcome distinct from failure.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class VariableExpression extends Expression {
  private final String variable;

  VariableExpression(String variable) {
    Preconditions.checkNotNull(variable);

    this.variable = variable.intern();
  }

  public String getVariable() {
    return variable;
  }

  private PackratGrammar cachedGrammar;
  private Rule cachedRule;

  public Rule getRule(PackratGrammar grammar) {
    if (grammar != cachedGrammar) {
      cachedGrammar = grammar;
      cachedRule = grammar.getRule(variable);
    }

    return cachedRule;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof VariableExpression)) {
      return false;
    }

    VariableExpression that = (VariableExpression) o;

    if (!variable.equals(that.variable)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return variable.hashCode();
  }

  @Override public <TInput,TResult> TResult accept(ExpressionVisitor<TInput,TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    return getVariable();
  }
}