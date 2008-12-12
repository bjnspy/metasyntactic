// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class StaticKeywordToken extends KeywordToken {
  public static final StaticKeywordToken instance = new StaticKeywordToken();

  private StaticKeywordToken() {
    super("static");
  }

  protected Type getTokenType() {
    return Type.StaticKeyword;
  }
}
