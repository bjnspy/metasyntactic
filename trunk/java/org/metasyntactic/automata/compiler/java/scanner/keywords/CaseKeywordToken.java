// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class CaseKeywordToken extends KeywordToken {
  public static final CaseKeywordToken instance = new CaseKeywordToken();

  private CaseKeywordToken() {
    super("case");
  }
}
