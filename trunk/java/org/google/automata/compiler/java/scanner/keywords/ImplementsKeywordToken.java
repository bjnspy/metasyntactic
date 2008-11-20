// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ImplementsKeywordToken extends KeywordToken {
  public static final ImplementsKeywordToken instance = new ImplementsKeywordToken();

  private ImplementsKeywordToken() {
    super("implements");
  }
}
