// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ShortKeywordToken extends KeywordToken {
  public static final ShortKeywordToken instance = new ShortKeywordToken();

  private ShortKeywordToken() {
    super("short");
  }
}
