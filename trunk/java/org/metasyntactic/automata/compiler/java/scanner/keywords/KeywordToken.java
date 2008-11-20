package org.metasyntactic.automata.compiler.java.scanner.keywords;

import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.HashMap;
import java.util.Map;

public abstract class KeywordToken extends JavaToken {
  private final static Map<String, KeywordToken> map = new HashMap<String, KeywordToken>();

  static {
    if (true) {
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
        "abstract", "continue", "for", "new", "switch",
        "assert", "default", "if", "package", "synchronized",
        "boolean", "do", "goto", "private", "this",
        "break", "double", "implements", "protected", "throw",
        "byte", "else", "import", "public", "throws",
        "case", "enum", "instanceof", "return", "transient",
        "catch", "extends", "int", "short", "try",
        "char", "final", "interface", "static", "void",
        "class", "finally", "long", "strictfp", "volatile",
        "const", "float", "native", "super", "while"};
  }

  @Override protected Type getTokenType() {
    return Type.Keyword;
  }
}