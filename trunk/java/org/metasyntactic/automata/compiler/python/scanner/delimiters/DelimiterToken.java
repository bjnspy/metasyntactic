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
    DelimiterToken[] tokens = new DelimiterToken[]{
        LeftParenthesisDelimiterToken.instance,
        RightParenthesisDelimiterToken.instance,
        LeftBracketDelimiterToken.instance,
        RightBracketDelimiterToken.instance,
        LeftCurlyDelimiterToken.instance,
        RightCurlyDelimiterToken.instance,
        AtDelimiterToken.instance,
        CommaDelimiterToken.instance,
        ColonDelimiterToken.instance,
        AndEqualsDelimiterToken.instance,
        BackQuoteDelimiterToken.instance,
        DivideEqualsDelimiterToken.instance,
        DotDelimiterToken.instance,
        EllipsisDelimiterToken.instance,
        EqualsDelimiterToken.instance,
        ExclusiveOrEqualsDelimiterToken.instance,
        ExponentEqualsDelimiterToken.instance,
        LeftShiftEqualsDelimiterToken.instance,
        MinusEqualsDelimiterToken.instance,
        ModulusEqualsDelimiterToken.instance,
        OrEqualsDelimiterToken.instance,
        PlusEqualsDelimiterToken.instance,
        RightShiftEqualsDelimiterToken.instance,
        SemicolonDelimiterToken.instance,
        TimesEqualsDelimiterToken.instance,
        TruncateDivideEqualsDelimiterToken.instance
    };
/*

        "(", ")", "[", "]", "{", "}", "@",
        ",", ":", ".", "...", "`", "=", ";",
        "+=", "-=", "*=", "/=", "//=", "%=",
        "&=", "|=", "^=", ">>=", "<<=", "**="
 */
    List<String> delimiters = Arrays.asList(getDelimiters());

    if (tokens.length != delimiters.size()) {
      throw new IllegalStateException();
    }

    for (DelimiterToken token : tokens) {
      String delimiter = token.getText();

      if (!delimiters.contains(delimiter)) {
        throw new IllegalStateException();
      }

      if (map.containsKey(delimiter)) {
        throw new IllegalStateException();
      }

      map.put(delimiter, token);
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

  public Type getTokenType() {
    return Type.Delimiter;
  }
}