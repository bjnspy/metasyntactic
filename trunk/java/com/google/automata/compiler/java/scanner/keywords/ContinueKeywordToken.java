// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ContinueKeywordToken extends KeywordToken {
  public static final ContinueKeywordToken instance = new ContinueKeywordToken();

  private ContinueKeywordToken() {
    super("continue");
  }
}
