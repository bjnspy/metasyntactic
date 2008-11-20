package com.google.automata.compiler.util;

import com.google.common.base.Preconditions;

import java.util.AbstractList;

public class StringList extends AbstractList<Character> {
  private final String string;

  public StringList(String string) {
    Preconditions.checkNotNull(string);
    this.string = string;
  }

  @Override public Character get(int i) {
    return string.charAt(i);
  }

  @Override public int size() {
    return string.length();
  }
}