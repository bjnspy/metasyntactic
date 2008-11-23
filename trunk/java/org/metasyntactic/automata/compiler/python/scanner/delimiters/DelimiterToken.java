package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:58:41 PM To change this template use File |
 * Settings | File Templates.
 */
public class DelimiterToken extends PythonToken {
  private static final Map<String, DelimiterToken> map = new LinkedHashMap<String, DelimiterToken>();

  static {
    Class[] classes = new Class[]{
        LeftParenthesisDelimiterToken.class,
        RightParenthesisDelimiterToken.class,
        LeftBracketDelimiterToken.class,
        RightBracketDelimiterToken.class,
        LeftCurlyDelimiterToken.class,
        RightCurlyDelimiterToken.class,
        AtDelimiterToken.class,
        CommaDelimiterToken.class,
        ColonDelimiterToken.class,
        AndEqualsDelimiterToken.class,
        BackQuoteDelimiterToken.class,
        DivideEqualsDelimiterToken.class,
        DotDelimiterToken.class,
        EllipsisDelimiterToken.class,
        EqualsDelimiterToken.class,
        ExclusiveOrEqualsDelimiterToken.class,
        ExponentEqualsDelimiterToken.class,
        LeftShiftEqualsDelimiterToken.class,
        MinusEqualsDelimiterToken.class,
        ModulusEqualsDelimiterToken.class,
        OrEqualsDelimiterToken.class,
        PlusEqualsDelimiterToken.class,
        RightShiftEqualsDelimiterToken.class,
        SemicolonDelimiterToken.class,
        TimesEqualsDelimiterToken.class,
        TruncateDivideEqualsDelimiterToken.class
    };
/*

        "(", ")", "[", "]", "{", "}", "@",
        ",", ":", ".", "...", "`", "=", ";",
        "+=", "-=", "*=", "/=", "//=", "%=",
        "&=", "|=", "^=", ">>=", "<<=", "**="
 */
    List<String> delimiters = Arrays.asList(getDelimiters());

    if (classes.length != delimiters.size()) {
      throw new IllegalStateException();
    }

    for (Class clazz : classes) {
      try {
        DelimiterToken token = (DelimiterToken) clazz.getField("instance").get(null);
        String delimiter = token.getText();

        if (!delimiters.contains(delimiter)) {
          throw new IllegalStateException();
        }

        if (map.containsKey(delimiter)) {
          throw new IllegalStateException();
        }

        map.put(delimiter, token);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (NoSuchFieldException e) {
        throw new RuntimeException(e);
      }
    }
  }

  public DelimiterToken(String text) {
    super(text);
  }

  public static String[] getDelimiters() {
    return new String[]{
        "(",
        ")",
        "[",
        "]",
        "{",
        "}",
        "@",
        ",",
        ":",
        ".",
        "...",
        "`",
        "=",
        ";",
        "+=",
        "-=",
        "*=",
        "/=",
        "//=",
        "%=",
        "&=",
        "|=",
        "^=",
        ">>=",
        "<<=",
        "**="
    };
  }

  public static DelimiterToken getDelimiterToken(String text) {
    DelimiterToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown delimiter: " + text);
    }

    return token;
  }

  @Override public Type getTokenType() {
    return Type.Delimiter;
  }
}