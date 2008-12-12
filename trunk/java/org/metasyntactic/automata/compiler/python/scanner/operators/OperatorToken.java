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
    OperatorToken[] tokens = new OperatorToken[]{
        AndOperatorToken.instance,
        BitwiseNotOperatorToken.instance,
        DivideOperatorToken.instance,
        EqualsEqualsOperatorToken.instance,
        ExclusiveOrOperatorToken.instance,
        ExponentOperatorToken.instance,
        GreaterThanOperatorToken.instance,
        GreaterThanOrEqualsOperatorToken.instance,
        LeftShiftOperatorToken.instance,
        RightShiftOperatorToken.instance,
        LessThanGreaterThanOperatorToken.instance,
        LessThanOperatorToken.instance,
        LessThanOrEqualsOperatorToken.instance,
        MinusOperatorToken.instance,
        ModulusOperatorToken.instance,
        NotEqualsOperatorToken.instance,
        OrOperatorToken.instance,
        PlusOperatorToken.instance,
        TimesOperatorToken.instance,
        TruncatingDivideOperatorToken.instance
    };

    List<String> operators = Arrays.asList(getOperators());

    if (tokens.length != operators.size()) {
      throw new IllegalStateException();
    }

    for (OperatorToken token : tokens) {
      String operator = token.getText();

      if (!operators.contains(operator)) {
        throw new IllegalStateException();
      }

      if (map.containsKey(operator)) {
        throw new IllegalStateException();
      }

      map.put(operator, token);
    }
  }

  public OperatorToken(String text) {
    super(text);
  }

  public static String[] getOperators() {
    return new String[]{
        "+", "-", "*", "**", "/", "//", "%", "<<", ">>", "&", "|", "^", "~", "<", ">", "<=", ">=", "==", "!=", "<>"
    };
  }

  public static OperatorToken getOperatorToken(String text) {
    OperatorToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown operator: " + text);
    }

    return token;
  }

  public Type getTokenType() {
    return Type.Operator;
  }
}