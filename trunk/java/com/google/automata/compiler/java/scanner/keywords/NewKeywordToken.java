// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class NewKeywordToken extends KeywordToken {
  public static final NewKeywordToken instance = new NewKeywordToken();

  private NewKeywordToken() {
    super("new");
  }
}
