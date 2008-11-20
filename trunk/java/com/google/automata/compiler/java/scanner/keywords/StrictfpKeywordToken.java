// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class StrictfpKeywordToken extends KeywordToken {
  public static final StrictfpKeywordToken instance = new StrictfpKeywordToken();

  private StrictfpKeywordToken() {
    super("strictfp");
  }
}
