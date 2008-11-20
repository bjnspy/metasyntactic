package org.metasyntactic.automata.compiler.framework.parsers;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 4:00:22 PM
 * To change this template use File | Settings | File Templates.
 */
public interface Span {
  Position getStartPosition();
  Position getEndPosition();
}

