// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ConstKeywordToken extends KeywordToken {
  public static final ConstKeywordToken instance = new ConstKeywordToken();

  private ConstKeywordToken() {
    super("const");
  }
}
