package org.metasyntactic.automata.compiler.python.scanner.keywords;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 2:04:01 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class KeywordToken extends PythonToken {
  private final static Map<String, KeywordToken> map = new HashMap<String, KeywordToken>();

  static {
    KeywordToken[] tokens = new KeywordToken[]{
        AndKeywordToken.instance,
        DelKeywordToken.instance,
        FromKeywordToken.instance,
        NotKeywordToken.instance,
        WhileKeywordToken.instance,
        AsKeywordToken.instance,
        ElifKeywordToken.instance,
        GlobalKeywordToken.instance,
        OrKeywordToken.instance,
        WithKeywordToken.instance,
        AssertKeywordToken.instance,
        ElseKeywordToken.instance,
        IfKeywordToken.instance,
        PassKeywordToken.instance,
        YieldKeywordToken.instance,
        BreakKeywordToken.instance,
        ExceptKeywordToken.instance,
        ImportKeywordToken.instance,
        PrintKeywordToken.instance,
        ClassKeywordToken.instance,
        ExecKeywordToken.instance,
        InKeywordToken.instance,
        RaiseKeywordToken.instance,
        ContinueKeywordToken.instance,
        FinallyKeywordToken.instance,
        IsKeywordToken.instance,
        ReturnKeywordToken.instance,
        DefKeywordToken.instance,
        ForKeywordToken.instance,
        LambdaKeywordToken.instance,
        TryKeywordToken.instance
    };

    for (KeywordToken token : tokens) {
      map.put(token.getText(), token);
    }
  }

  protected KeywordToken(String text) {
    super(text);
  }

  public static KeywordToken getKeywordToken(String text) {
    KeywordToken token = map.get(text);

    if (token == null) {
      throw new IllegalArgumentException("Unknown keyword: " + text);
    }

    return token;
  }

  public static String[] getKeywords() {
    return new String[]{
        "and",
        "del",
        "from",
        "not",
        "while",
        "as",
        "elif",
        "global",
        "or",
        "with",
        "assert",
        "else",
        "if",
        "pass",
        "yield",
        "break",
        "except",
        "import",
        "print",
        "class",
        "exec",
        "in",
        "raise",
        "continue",
        "finally",
        "is",
        "return",
        "def",
        "for",
        "lambda",
        "try"
    };
  }

  public Type getTokenType() {
    return Type.Keyword;
  }
}

