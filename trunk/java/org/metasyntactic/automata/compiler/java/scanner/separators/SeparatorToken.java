package org.metasyntactic.automata.compiler.java.scanner.separators;

import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:59:45 PM To change this template use File |
 * Settings | File Templates.
 */
public class SeparatorToken extends JavaToken {
  private final static Map<String, SeparatorToken> map = new LinkedHashMap<String, SeparatorToken>();

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
  }

  public SeparatorToken(String text) {
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

  @Override protected Type getTokenType() {
    return Type.Separator;
  }
}