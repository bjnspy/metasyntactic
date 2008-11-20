// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class FloatKeywordToken extends KeywordToken {
  public static final FloatKeywordToken instance = new FloatKeywordToken();

  private FloatKeywordToken() {
    super("float");
  }
}
