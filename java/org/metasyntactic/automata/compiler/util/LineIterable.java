package org.metasyntactic.automata.compiler.util;

import java.io.IOException;
import java.io.LineNumberReader;
import java.io.StringReader;
import java.util.Iterator;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 4:03:38 PM To change this template use File |
 * Settings | File Templates.
 */
public class LineIterable implements Iterable<String> {
  private final String text;

  public LineIterable(String text) {
    this.text = text;
  }

   public Iterator<String> iterator() {
    final LineNumberReader in = new LineNumberReader(new StringReader(text));
    return new Iterator<String>() {
      private String next;

       public boolean hasNext() {
        try {
          next = in.readLine();
        } catch (IOException e) {
          throw new RuntimeException(e);
        }
        return next != null;
      }

       public String next() {
        return next;
      }

       public void remove() {
        throw new UnsupportedOperationException();
      }
    };
  }
}
