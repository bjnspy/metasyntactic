// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class CaseKeywordToken extends KeywordToken {
  public static final CaseKeywordToken instance = new CaseKeywordToken();

  private CaseKeywordToken() {
    super("case");
  }

  protected Type getTokenType() {
    return Type.CaseKeyword;
  }
}
