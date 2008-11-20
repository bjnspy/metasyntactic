// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class InterfaceKeywordToken extends KeywordToken {
  public static final InterfaceKeywordToken instance = new InterfaceKeywordToken();

  private InterfaceKeywordToken() {
    super("interface");
  }
}
