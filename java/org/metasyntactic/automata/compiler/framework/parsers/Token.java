package org.metasyntactic.automata.compiler.framework.parsers;

public interface Token extends Comparable<Token> {
  String getText();

  int getType();

  //Class<? extends Token> getRepresentativeClass();
}
