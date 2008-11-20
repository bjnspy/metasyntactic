// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ThrowKeywordToken extends KeywordToken {
  public static final ThrowKeywordToken instance = new ThrowKeywordToken();

  private ThrowKeywordToken() {
    super("throw");
  }
}
