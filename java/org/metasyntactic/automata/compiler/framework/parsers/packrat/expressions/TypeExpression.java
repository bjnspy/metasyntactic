package org.metasyntactic.automata.compiler.framework.parsers.packrat.expressions;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.utilities.ReflectionUtilities;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class TypeExpression extends Expression {
  public final Class<? extends Token> type;

  protected TypeExpression(Class<? extends Token> type) {
    this.type = type;
  }

  public Class<? extends Token> getType() {
    return type;
  }

  private Set<Integer> types;

  @SuppressWarnings("unchecked")
  public Set<Integer> getTypes() {
    try {
      if (types == null) {
        Method[] methods = type.getMethods();
        Set<String> methodNames = new LinkedHashSet<String>();
        for (Method method : methods) {
          methodNames.add(method.getName());
        }

        if (methodNames.contains("getTypeValue")) {
          types = Collections.singleton((Integer) type.getMethod("getTypeValue").invoke(null));
        } else if (methodNames.contains("getTokenClasses")) {
          Set<Class<? extends Token>> classes;
          classes = (Set<Class<? extends Token>>) type.getMethod("getTokenClasses").invoke(null);

          Set<Integer> result = new LinkedHashSet<Integer>();

          for (Class<? extends Token> clazz : classes) {
            Token token;
            if (ReflectionUtilities.hasField(clazz, "instance")) {
              token = (Token) clazz.getField("instance").get(null);
            } else {
              token = clazz.getConstructor(String.class).newInstance("");
            }
            result.add(token.getType());
          }

          types = result;
        } else {
          throw new RuntimeException("Illegal state");
        }
      }

      return types;
    } catch (IllegalAccessException e) {
      throw new RuntimeException(e);
    } catch (InstantiationException e) {
      throw new RuntimeException(e);
    } catch (NoSuchMethodException e) {
      throw new RuntimeException(e);
    } catch (InvocationTargetException e) {
      throw new RuntimeException(e);
    } catch (NoSuchFieldException e) {
      throw new RuntimeException(e);
    }
  }

   public boolean equals(Object o) {
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

   public int hashCodeWorker() {
    return type.hashCode();
  }

   public <TInput, TResult> TResult accept(ExpressionVisitor<TInput, TResult> visitor) {
    return visitor.visit(this);
  }

   public <TInput> void accept(ExpressionVoidVisitor<TInput> visitor) {
    visitor.visit(this);
  }

   public String toString() {
    return type.getSimpleName();
  }
}
