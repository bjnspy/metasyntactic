package org.metasyntactic.automata.compiler.python.scanner.operators;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:58:41 PM To change this template use File |
 * Settings | File Templates.
 */
public class OperatorToken extends PythonToken {
  private static final Map<String, OperatorToken> map = new LinkedHashMap<String, OperatorToken>();

  static {
    Class[] classes = new Class[]{
        AndOperatorToken.class,
        BitwiseNotOperatorToken.class,
        DivideOperatorToken.class,
        EqualsEqualsOperatorToken.class,
        ExclusiveOrOperatorToken.class,
        ExponentOperatorToken.class,
        GreaterThanOperatorToken.class,
        GreaterThanOrEqualsOperatorToken.class,
        LeftShiftOperatorToken.class,
        RightShiftOperatorToken.class,
        LessThanGreaterThanOperatorToken.class,
        LessThanOperatorToken.class,
        LessThanOrEqualsOperatorToken.class,
        MinusOperatorToken.class,
        ModulusOperatorToken.class,
        NotEqualsOperatorToken.class,
        OrOperatorToken.class,
        PlusOperatorToken.class,
        TimesOperatorToken.class,
        TruncatingDivideOperatorToken.class
    };

    List<String> operators = Arrays.asList(getOperators());

    if (classes.length != operators.size()) {
      throw new IllegalStateException();
    }

    for (Class clazz : classes) {
      try {
        OperatorToken token = (OperatorToken) clazz.getField("instance").get(null);
        String operator = token.getText();

        if (!operators.contains(operator)) {
          throw new IllegalStateException();
        }

        if (map.containsKey(operator)) {
          throw new IllegalStateException();
        }

        map.put(operator, token);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (NoSuchFieldException e) {
        throw new RuntimeException(e);
      }
    }
  }

  public OperatorToken(String text) {
    super(text);
  }

  public static String[] getOperators() {
    return new String[]{
        "+", "-", "*", "**", "/", "//", "%",
        "<<", ">>", "&", "|", "^", "~",
        "<", ">", "<=", ">=", "==", "!=", "<>"
    };
  }

  public static OperatorToken getOperatorToken(String text) {
    OperatorToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown operator: " + text);
    }

    return token;
  }

  @Override public Type getTokenType() {
    return Type.Operator;
  }
}