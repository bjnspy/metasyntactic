package org.metasyntactic.io;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.Date;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PersistableOutputStream extends ObjectOutputStream {
  public PersistableOutputStream(OutputStream out) throws IOException {
    super(out);
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
      writeUTF(string);
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