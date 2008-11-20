// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class VoidKeywordToken extends KeywordToken {
  public static final VoidKeywordToken instance = new VoidKeywordToken();

  private VoidKeywordToken() {
    super("void");
  }
}
