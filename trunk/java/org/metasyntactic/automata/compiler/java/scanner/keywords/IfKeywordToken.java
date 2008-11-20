// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class IfKeywordToken extends KeywordToken {
  public static final IfKeywordToken instance = new IfKeywordToken();

  private IfKeywordToken() {
    super("if");
  }
}
