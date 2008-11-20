// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ClassKeywordToken extends KeywordToken {
  public static final ClassKeywordToken instance = new ClassKeywordToken();

  private ClassKeywordToken() {
    super("class");
  }
}
