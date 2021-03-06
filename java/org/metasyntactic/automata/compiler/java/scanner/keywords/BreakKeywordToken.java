// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class BreakKeywordToken extends KeywordToken {
  public static final BreakKeywordToken instance = new BreakKeywordToken();

  private BreakKeywordToken() {
    super("break");
  }

  protected Type getTokenType() {
    return Type.BreakKeyword;
  }
}
