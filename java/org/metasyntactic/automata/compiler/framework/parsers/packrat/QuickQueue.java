package org.metasyntactic.automata.compiler.framework.parsers.packrat;

/**
 * Implementation of a Queue designed to have as little overhead as possible.
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class QuickQueue<T> {
  private T[] array = (T[]) new Object[16];
  private int size;

  public QuickQueue() {

  }

  public void offer(T value) {
    if (size == array.length) {
      T[] copy = (T[])new Object[size * 2];
      System.arraycopy(array, 0, copy, 0, array.length);
      array = copy;
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
