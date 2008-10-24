package org.metasyntactic.io;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PersistableInputStream {
  private final InputStream in;


  public PersistableInputStream(InputStream in) {
    this.in = in;
  }


  public void close() throws IOException {
  	in.close();
  }


  private void readEntireArray(byte[] bytes) throws IOException {
    int position = 0;

    while (true) {
      int read = in.read(bytes, position, bytes.length - position);
      if (read + position == bytes.length) {
        break;
      }

      position += read;
    }
  }


  private final byte[] bytes4 = new byte[4];
  private final byte[] bytes8 = new byte[8];
  private final ByteBuffer buffer4 = ByteBuffer.wrap(bytes4);
  private final ByteBuffer buffer8 = ByteBuffer.wrap(bytes8);


  public int readInt() throws IOException {
    readEntireArray(bytes4);
    return buffer4.getInt(0);
  }


  public long readLong() throws IOException {
    readEntireArray(bytes8);
    return buffer8.getLong(0);
  }


  public double readDouble() throws IOException {
    readEntireArray(bytes8);
    return buffer8.getDouble(0);
  }


  public String readString() throws IOException {
    int size = readInt();

    byte[] bytes = new byte[size * 2];
    readEntireArray(bytes);

    ByteBuffer buffer = ByteBuffer.wrap(bytes);

    return new String(buffer.asCharBuffer().array());
  }


  public <T extends Persistable> T readPersistable(Persistable.Reader<T> reader) throws IOException {
    return reader.read(this);
  }


  public List<String> readStringList() throws IOException {
    int size = readInt();
    List<String> result = new ArrayList<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readString());
    }
    return result;
  }


  public Set<String> readStringSet() throws IOException {
    int size = readInt();
    Set<String> result = new HashSet<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readString());
    }
    return result;
  }


  public Date readDate() throws IOException {
    long millis = readLong();
    if (millis == -1) {
      return null;
    }

    return new Date(millis);
  }
}
