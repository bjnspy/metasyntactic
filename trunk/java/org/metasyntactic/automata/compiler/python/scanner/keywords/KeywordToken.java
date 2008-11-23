package org.metasyntactic.automata.compiler.python.scanner.keywords;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 2:04:01 PM To change this template use File |
 * Settings | File Templates.
 */
public abstract class KeywordToken extends PythonToken {
  static {
    /*
    for (String keyword : getKeywords()) {
      String className = Character.toUpperCase(keyword.charAt(0)) + keyword.substring(1) + "KeywordToken";
      System.out.println("public class " + className + " extends KeywordToken {");
      System.out.println("  public static final " + className + " instance = new " + className + "();");
      System.out.println();
      System.out.println("  private " + className + "() {");
      System.out.println("    super(\"" + keyword + "\");");
      System.out.println("  }");
      System.out.println("}");
    }
    */
  }

  private final static Map<String, KeywordToken> map = new HashMap<String, KeywordToken>();

  static {
    for (String keyword : getKeywords()) {
      String className = Character.toUpperCase(keyword.charAt(0)) + keyword.substring(1) + "KeywordToken";

      try {
        Class clazz = Class.forName(KeywordToken.class.getPackage().getName() + "." + className);

        KeywordToken token = (KeywordToken) clazz.getField("instance").get(null);

        map.put(keyword, token);
      } catch (ClassNotFoundException e) {
        throw new RuntimeException(e);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (NoSuchFieldException e) {
        throw new RuntimeException(e);
      }
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

  @Override public Type getTokenType() {
    return Type.Keyword;
  }
}

