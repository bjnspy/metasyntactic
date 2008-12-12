// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class LongKeywordToken extends KeywordToken {
  public static final LongKeywordToken instance = new LongKeywordToken();

  private LongKeywordToken() {
    super("long");
  }

  protected Type getTokenType() {
    return Type.LongKeyword;
  }
}
