// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class AbstractKeywordToken extends KeywordToken {
  public static final AbstractKeywordToken instance = new AbstractKeywordToken();

  private AbstractKeywordToken() {
    super("abstract");
  }
}
