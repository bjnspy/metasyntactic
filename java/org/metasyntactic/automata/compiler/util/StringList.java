package org.metasyntactic.automata.compiler.util;

import org.metasyntactic.common.base.Preconditions;

import java.util.AbstractList;

public class StringList extends AbstractList<Character> {
  private final String string;

  public StringList(String string) {
    Preconditions.checkNotNull(string);
    this.string = string;
  }

   public Character get(int i) {
    return string.charAt(i);
  }

   public int size() {
    return string.length();
  }
}