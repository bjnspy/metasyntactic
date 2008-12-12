package org.metasyntactic.automata.compiler.java.scanner.operators;

import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:58:41 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class OperatorToken extends JavaToken {
  private static final Map<String, OperatorToken> map = new LinkedHashMap<String, OperatorToken>();

  static {
    OperatorToken[] tokens = new OperatorToken[]{
        EqualsOperatorToken.instance,
        GreaterThanOperatorToken.instance,
        LessThanOperatorToken.instance,
        LogicalNotOperatorToken.instance,
        BitwiseNotOperatorToken.instance,
        QuestionMarkOperatorToken.instance,
        ColonOperatorToken.instance,
        EqualsEqualsOperatorToken.instance,
        LessThanOrEqualsOperatorToken.instance,
        GreaterThanOrEqualsOperatorToken.instance,
        NotEqualsOperatorToken.instance,
        LogicalAndOperatorToken.instance,
        LogicalOrOperatorToken.instance,
        IncrementOperatorToken.instance,
        DecrementOperatorToken.instance,
        PlusOperatorToken.instance,
        MinusOperatorToken.instance,
        TimesOperatorToken.instance,
        DivideOperatorToken.instance,
        BitwiseAndOperatorToken.instance,
        BitwiseOrOperatorToken.instance,
        BitwiseExclusiveOrOperatorToken.instance,
        ModulusOperatorToken.instance,
        LeftShiftOperatorToken.instance,
        //RightShiftOperatorToken.instance,
        //BitwiseRightShiftOperatorToken.instance,
        PlusEqualsOperatorToken.instance,
        MinusEqualsOperatorToken.instance,
        TimesEqualsOperatorToken.instance,
        DivideEqualsOperatorToken.instance,
        AndEqualsOperatorToken.instance,
        OrEqualsOperatorToken.instance,
        ExclusiveOrEqualsOperatorToken.instance,
        ModulusEqualsOperatorToken.instance,
        LeftShiftEqualsOperatorToken.instance,
        RightShiftEqualsOperatorToken.instance,
        BitwiseRightShiftEqualsOperatorToken.instance
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

  public static OperatorToken getOperatorToken(String text) {
    OperatorToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown operator: " + text);
    }

    return token;
  }

  public static String[] getOperators() {
    return new String[]{
        "=",
        ">",
        "<",
        "!",
        "~",
        "?",
        ":",
        "==",
        "<=",
        ">=",
        "!=",
        "&&",
        "||",
        "++",
        "--",
        "+",
        "-",
        "*",
        "/",
        "&",
        "|",
        "^",
        "%",
        "<<",
        /*">>", ">>>",*/
        "+=",
        "-=",
        "*=",
        "/=",
        "&=",
        "|=",
        "^=",
        "%=",
        "<<=",
        ">>=",
        ">>>="
    };
  }
}