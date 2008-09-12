package org.metasyntactic.io;

import java.io.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class IOUtilities {
  private IOUtilities() {

  }


  public static byte[] writeObject(Object object) throws IOException {
    if (object == null) {
      return null;
    }

    ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
    ObjectOutputStream objectOut = new ObjectOutputStream(byteOut);
    objectOut.writeObject(object);
    objectOut.flush();

    return byteOut.toByteArray();
  }


  public static Object readObject(byte[] bytes) throws IOException, ClassNotFoundException {
    if (bytes == null) {
      return null;
    }

    ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes));
    return in.readObject();
  }
}
