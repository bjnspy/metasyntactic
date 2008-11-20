// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class InstanceofKeywordToken extends KeywordToken {
  public static final InstanceofKeywordToken instance = new InstanceofKeywordToken();

  private InstanceofKeywordToken() {
    super("instanceof");
  }
}
