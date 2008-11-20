// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class LongKeywordToken extends KeywordToken {
  public static final LongKeywordToken instance = new LongKeywordToken();

  private LongKeywordToken() {
    super("long");
  }
}
