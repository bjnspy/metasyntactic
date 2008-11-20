// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class SwitchKeywordToken extends KeywordToken {
  public static final SwitchKeywordToken instance = new SwitchKeywordToken();

  private SwitchKeywordToken() {
    super("switch");
  }
}
