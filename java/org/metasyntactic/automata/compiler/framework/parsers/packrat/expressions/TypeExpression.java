package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.automata.compiler.framework.parsers.Token;

import java.lang.reflect.InvocationTargetException;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TypeExpression extends Expression {
  public final Class<? extends Token> type;
  public final int typeValue;

  public TypeExpression(Class<? extends Token> type) {
    this.type = type;

    try {
      typeValue = (Integer)type.getMethod("typeValue").invoke(null);
    } catch (IllegalAccessException e) {
      throw new RuntimeException(e);
    } catch (InvocationTargetException e) {
      throw new RuntimeException(e);
    } catch (NoSuchMethodException e) {
      throw new RuntimeException(e);
    }
  }

  public Class<? extends Token> getType() {
    return type;
  }

  public int getTypeValue() {
    return typeValue;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }

    TypeExpression that = (TypeExpression) o;

    if (!type.equals(that.type)) {
      return false;
    }

    return true;
  }

  @Override public int hashCodeWorker() {
    return type.hashCode();
  }

  @Override public <TInput,TResult> TResult accept(ExpressionVisitor<TInput,TResult> visitor) {
    return visitor.visit(this);
  }

  @Override public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

  @Override public String toString() {
    return type.getSimpleName();
  }
}
