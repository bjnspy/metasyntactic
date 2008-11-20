// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class FinallyKeywordToken extends KeywordToken {
  public static final FinallyKeywordToken instance = new FinallyKeywordToken();

  private FinallyKeywordToken() {
    super("finally");
  }
}
