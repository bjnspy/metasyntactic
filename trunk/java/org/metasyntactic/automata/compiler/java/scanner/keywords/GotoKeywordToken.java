// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class GotoKeywordToken extends KeywordToken {
  public static final GotoKeywordToken instance = new GotoKeywordToken();

  private GotoKeywordToken() {
    super("goto");
  }
}
