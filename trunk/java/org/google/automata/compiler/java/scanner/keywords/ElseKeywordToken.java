// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ElseKeywordToken extends KeywordToken {
  public static final ElseKeywordToken instance = new ElseKeywordToken();

  private ElseKeywordToken() {
    super("else");
  }
}
