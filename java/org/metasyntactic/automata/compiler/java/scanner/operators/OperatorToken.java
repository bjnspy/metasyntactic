package org.metasyntactic.automata.compiler.java.scanner.operators;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.*;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:58:41 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class OperatorToken extends JavaToken {
  private static final Map<String, OperatorToken> map = new LinkedHashMap<String, OperatorToken>();
  public static Set<Class<? extends Token>> tokenClasses = new LinkedHashSet<Class<? extends Token>>();

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

    tokenClasses.addAll(Arrays.<Class<? extends Token>>asList(classes));
  }

  public static Set<Class<? extends Token>> getTokenClasses() {
    return tokenClasses;
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

  public Class<? extends Token> getRepresentativeClass() {
    return this.getClass();
  }

  private Type type;

  protected Type getTokenType() {
    if (type == null) {
      String name = this.getClass().getName();
      name = name.substring(0, name.length() - "Token".length());

      try {
        type = (Type) Type.class.getField(name).get(null);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (NoSuchFieldException e) {
        throw new RuntimeException(e);
      }
    }

    return type;
  }
}