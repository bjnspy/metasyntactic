package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TypeExpression extends Expression {
  private final String name;
  private final Set<Integer> types;

  public TypeExpression(String name, Set<Integer> types) {
    this.name = name;
    this.types = types;
  }

  public TypeExpression(String name, Integer... types) {
    this(name, new LinkedHashSet<Integer>(Arrays.asList(types)));
  }

  public String getName() {
    return name;
  }

  public Set<Integer> getTypes() {
    return types;
  }

  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    TypeExpression that = (TypeExpression) o;

    if (!types.equals(that.getTypes())) {
      return false;
    }

    return true;
  }

  public int hashCodeWorker() {
    return types.hashCode();
  }

  public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

  public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  public String toString() {
    return getName();
  }
}
