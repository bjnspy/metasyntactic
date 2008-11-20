package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.common.base.Preconditions;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 4:00:52 PM
 * To change this template use File | Settings | File Templates.
 */
public class Position {
  private final int line;
  private final int character;

  public Position(int line, int character) {
    Preconditions.checkArgument(line >= 0);
    Preconditions.checkArgument(character >= 0);

    this.line = line;
    this.character = character;
  }

  public int getLine() {
    return line;
  }

  public int getCharacter() {
    return character;
  }

  @Override public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Position)) return false;

    Position position = (Position) o;

    if (character != position.character) return false;
    if (line != position.line) return false;

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = line;
    result = 31 * result + character;
    return result;
  }

  @Override public String toString() {
    return "(" + line + ", " + character + ")";
  }
}
