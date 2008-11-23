package org.metasyntactic.automata.compiler.java.scanner.separators;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.*;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:59:45 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class SeparatorToken extends JavaToken {
  private final static Map<String, SeparatorToken> map = new LinkedHashMap<String, SeparatorToken>();
  public final static Set<Class<? extends Token>> tokenClasses = new LinkedHashSet<Class<? extends Token>>();

  static {
    Class[] classes = new Class[]{
        AtSeparatorToken.class,
        LeftParenthesisSeparatorToken.class,
        RightParenthesisSeparatorToken.class,
        LeftBracketSeparatorToken.class,
        RightBracketSeparatorToken.class,
        LeftCurlySeparatorToken.class,
        RightCurlySeparatorToken.class,
        SemicolonSeparatorToken.class,
        CommaSeparatorToken.class,
        DotSeparatorToken.class,
        EllipsisSeparatorToken.class
    };

    List<String> separators = Arrays.asList(getSeparators());

    if (classes.length != separators.size()) {
      throw new IllegalStateException();
    }

    for (Class clazz : classes) {
      try {
        SeparatorToken token = (SeparatorToken) clazz.getField("instance").get(null);
        String separator = token.getText();

        if (!separators.contains(separator)) {
          throw new IllegalStateException();
        }

        if (map.containsKey(separator)) {
          throw new IllegalStateException();
        }

        map.put(separator, token);
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

  protected SeparatorToken(String text) {
    super(text);
  }

  public static String[] getSeparators() {
    return new String[]{
        "@", "(", ")", "{", "}", "[", "]", ";", ",", ".", "..."
    };
  }

  public static SeparatorToken getSeparatorToken(String text) {
    SeparatorToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown separator: " + text);
    }

    return token;
  }

  private Type type;

  protected Type getTokenType() {
    if (type == null) {
      String name = this.getClass().getSimpleName();
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