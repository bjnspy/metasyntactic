// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ThrowsKeywordToken extends KeywordToken {
  public static final ThrowsKeywordToken instance = new ThrowsKeywordToken();

  private ThrowsKeywordToken() {
    super("throws");
  }
}
