// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class FloatKeywordToken extends KeywordToken {
  public static final FloatKeywordToken instance = new FloatKeywordToken();

  private FloatKeywordToken() {
    super("float");
  }

  protected Type getTokenType() {
    return Type.FloatKeyword;
  }
}
