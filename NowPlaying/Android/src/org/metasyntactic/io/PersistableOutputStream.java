package org.metasyntactic.io;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.Date;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PersistableOutputStream {
  private final OutputStream out;

  public PersistableOutputStream(OutputStream out) {
    this.out = out;
  }

  public void close() throws IOException {
    flush();
    out.close();
  }


  public void flush() throws IOException {
    out.flush();
  }


  private final byte[] bytes4 = new byte[4];
  private final byte[] bytes8 = new byte[8];
  private final ByteBuffer buffer4 = ByteBuffer.wrap(bytes4);
  private final ByteBuffer buffer8 = ByteBuffer.wrap(bytes8);

  public void writeInt(int i) throws IOException {
    buffer4.putInt(0, i);
    out.write(bytes4);
  }


  public void writeLong(long v) throws IOException {
    buffer8.putLong(0, v);
    out.write(bytes8);
  }


  public void writeDouble(double d) throws IOException {
    buffer8.putDouble(0, d);
    out.write(bytes8);
  }


  public void writeString(String s) throws IOException {
    writeInt(s.length());

    ByteBuffer buffer = ByteBuffer.allocate(s.length() * 2);
    buffer.asCharBuffer().put(s.toCharArray());

    out.write(buffer.array());
  }


  public void writePersistable(Persistable persistable) throws IOException {
    persistable.persistTo(this);
  }


  public <T extends Persistable> void writePersistableCollection(Collection<T> collection) throws IOException {
    writeInt(collection.size());
    for (T t : collection) {
      writePersistable(t);
    }
  }


  public void writeStringCollection(Collection<String> collection) throws IOException {
    writeInt(collection.size());
    for (String string : collection) {
      writeString(string);
    }
  }


  public void writeDate(Date date) throws IOException {
    if (date == null) {
      writeLong(-1);
    } else {
      writeLong(date.getTime());
    }
  }
}