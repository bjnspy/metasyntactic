// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class DoKeywordToken extends KeywordToken {
  public static final DoKeywordToken instance = new DoKeywordToken();

  private DoKeywordToken() {
    super("do");
  }
}
