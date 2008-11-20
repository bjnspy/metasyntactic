// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class DefaultKeywordToken extends KeywordToken {
  public static final DefaultKeywordToken instance = new DefaultKeywordToken();

  private DefaultKeywordToken() {
    super("default");
  }
}
