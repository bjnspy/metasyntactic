// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.separators;

public class AtSeparatorToken extends SeparatorToken {
  public final static AtSeparatorToken instance = new AtSeparatorToken();

  private AtSeparatorToken() {
    super("@");
  }
}
