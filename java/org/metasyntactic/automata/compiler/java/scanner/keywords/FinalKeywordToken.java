// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class FinalKeywordToken extends KeywordToken {
  public static final FinalKeywordToken instance = new FinalKeywordToken();

  private FinalKeywordToken() {
    super("final");
  }
}
