// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class CharKeywordToken extends KeywordToken {
  public static final CharKeywordToken instance = new CharKeywordToken();

  private CharKeywordToken() {
    super("char");
  }

  protected Type getTokenType() {
    return Type.CharKeyword;
  }
}
