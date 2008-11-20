// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class IntKeywordToken extends KeywordToken {
  public static final IntKeywordToken instance = new IntKeywordToken();

  private IntKeywordToken() {
    super("int");
  }
}
