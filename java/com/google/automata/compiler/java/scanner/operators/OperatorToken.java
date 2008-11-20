package com.google.automata.compiler.java.scanner.operators;

import com.google.automata.compiler.java.scanner.JavaToken;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:58:41 PM To change this template use File |
 * Settings | File Templates.
 */
public class OperatorToken extends JavaToken {
  private static final Map<String, OperatorToken> map = new LinkedHashMap<String, OperatorToken>();

  static {
    Class[] classes = new Class[]{
        EqualsOperatorToken.class,
        GreaterThanOperatorToken.class,
        LessThanOperatorToken.class,
        LogicalNotOperatorToken.class,
        BitwiseNotOperatorToken.class,
        QuestionMarkOperatorToken.class,
        ColonOperatorToken.class,
        EqualsEqualsOperatorToken.class,
        LessThanOrEqualsOperatorToken.class,
        GreaterThanOrEqualsOperatorToken.class,
        NotEqualsOperatorToken.class,
        LogicalAndOperatorToken.class,
        LogicalOrOperatorToken.class,
        IncrementOperatorToken.class,
        DecrementOperatorToken.class,
        PlusOperatorToken.class,
        MinusOperatorToken.class,
        TimesOperatorToken.class,
        DivideOperatorToken.class,
        BitwiseAndOperatorToken.class,
        BitwiseOrOperatorToken.class,
        BitwiseExclusiveOrOperatorToken.class,
        ModulusOperatorToken.class,
        LeftShiftOperatorToken.class,
        //RightShiftOperatorToken.class,
        //BitwiseRightShiftOperatorToken.class,
        PlusEqualsOperatorToken.class,
        MinusEqualsOperatorToken.class,
        TimesEqualsOperatorToken.class,
        DivideEqualsOperatorToken.class,
        AndEqualsOperatorToken.class,
        OrEqualsOperatorToken.class,
        ExclusiveOrEqualsOperatorToken.class,
        ModulusEqualsOperatorToken.class,
        LeftShiftEqualsOperatorToken.class,
        RightShiftEqualsOperatorToken.class,
        BitwiseRightShiftEqualsOperatorToken.class
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

  public static OperatorToken getOperatorToken(String text) {
    OperatorToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown operator: " + text);
    }

    return token;
  }

  public static String[] getOperators() {
    return new String[]{
        "=", ">", "<", "!", "~", "?", ":",
        "==", "<=", ">=", "!=", "&&", "||", "++", "--",
        "+", "-", "*", "/", "&", "|", "^", "%", "<<", /*">>", ">>>",*/
        "+=", "-=", "*=", "/=", "&=", "|=", "^=", "%=", "<<=", ">>=", ">>>="};
  }

  @Override protected Type getTokenType() {
    return Type.Operator;
  }
}