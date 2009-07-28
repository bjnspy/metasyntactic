// Copyright 2009 Google Inc. All Rights Reserved.
package com.google.protobuf;

/**
 * Thrown by blocking RPC methods when a failure occurs.
 *
 * @author cpovirk@google.com (Chris Povirk)
 */
public final class ServiceException extends Exception {
  private static final long serialVersionUID = -1219262335729891920L;

  public ServiceException(final String message) {
    super(message);
  }
}
