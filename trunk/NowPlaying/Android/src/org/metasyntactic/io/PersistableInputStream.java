package org.metasyntactic.io;

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PersistableInputStream extends ObjectInputStream {
  public PersistableInputStream(InputStream in) throws IOException {
    super(in);
  }


  public <T extends Persistable> T readPersistable(Persistable.Reader<T> reader) throws IOException {
    return reader.read(this);
  }


  public List<String> readStringList() throws IOException {
    int size = readInt();
    List<String> result = new ArrayList<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readUTF());
    }
    return result;
  }


  public Set<String> readStringSet() throws IOException {
    int size = readInt();
    Set<String> result = new HashSet<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readUTF());
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
