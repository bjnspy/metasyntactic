// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers;

import com.google.common.base.Preconditions;

public class SimpleSpan extends AbstractSpan implements Span {
  private final Position startPosition;
  private final Position endPosition;

  public SimpleSpan(Position startPosition, Position endPosition) {
    Preconditions.checkNotNull(startPosition);
    Preconditions.checkNotNull(endPosition);
    this.startPosition = startPosition;
    this.endPosition = endPosition;
  }

  @Override public Position getStartPosition() {
    return startPosition;
  }

  @Override public Position getEndPosition() {
    return endPosition;
  }
}
