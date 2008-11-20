// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ExtendsKeywordToken extends KeywordToken {
  public static final ExtendsKeywordToken instance = new ExtendsKeywordToken();

  private ExtendsKeywordToken() {
    super("extends");
  }
}
