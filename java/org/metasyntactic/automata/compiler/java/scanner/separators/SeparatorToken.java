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
public abstract class SeparatorToken extends JavaToken {
  private final static Map<String, SeparatorToken> map = new LinkedHashMap<String, SeparatorToken>();

  static {
    SeparatorToken[] tokens = new SeparatorToken[]{
        AtSeparatorToken.instance,
        LeftParenthesisSeparatorToken.instance,
        RightParenthesisSeparatorToken.instance,
        LeftBracketSeparatorToken.instance,
        RightBracketSeparatorToken.instance,
        LeftCurlySeparatorToken.instance,
        RightCurlySeparatorToken.instance,
        SemicolonSeparatorToken.instance,
        CommaSeparatorToken.instance,
        DotSeparatorToken.instance,
        EllipsisSeparatorToken.instance
    };

    List<String> separators = Arrays.asList(getSeparators());

    if (tokens.length != separators.size()) {
      throw new IllegalStateException();
    }

    for (SeparatorToken token : tokens) {
      String separator = token.getText();

      if (!separators.contains(separator)) {
        throw new IllegalStateException();
      }

      if (map.containsKey(separator)) {
        throw new IllegalStateException();
      }

      map.put(separator, token);
    }
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
}