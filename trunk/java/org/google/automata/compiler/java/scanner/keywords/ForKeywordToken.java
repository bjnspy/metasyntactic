// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ForKeywordToken extends KeywordToken {
  public static final ForKeywordToken instance = new ForKeywordToken();

  private ForKeywordToken() {
    super("for");
  }
}
