// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class SwitchKeywordToken extends KeywordToken {
  public static final SwitchKeywordToken instance = new SwitchKeywordToken();

  private SwitchKeywordToken() {
    super("switch");
  }
}
