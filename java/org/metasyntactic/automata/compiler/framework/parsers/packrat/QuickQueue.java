package org.metasyntactic.automata.compiler.framework.parsers.packrat;

import java.util.Arrays;

/**
 * Implementation of a Queue designed to have as little overhead as possible.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class QuickQueue<T> {
  private T[] array = (T[])new Object[16];
  private int size;

  public QuickQueue() {

  }

  public void offer(T value) {
    if (size == array.length) {
      array = Arrays.copyOf(array, size * 2);
    }

    array[size++] = value;
  }

  public T poll() {
    if (size == 0) {
      return null;
    }

    T result = array[--size];
    array[size] = null;

    return result;
  }
}
