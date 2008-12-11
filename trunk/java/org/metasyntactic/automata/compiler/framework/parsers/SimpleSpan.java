// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.common.base.Preconditions;

public class SimpleSpan extends AbstractSpan implements Span {
  private final Position startPosition;
  private final Position endPosition;

  public SimpleSpan(Position startPosition, Position endPosition) {
    Preconditions.checkNotNull(startPosition);
    Preconditions.checkNotNull(endPosition);
    this.startPosition = startPosition;
    this.endPosition = endPosition;
  }

   public Position getStartPosition() {
    return startPosition;
  }

   public Position getEndPosition() {
    return endPosition;
  }
}
