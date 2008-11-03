package org.metasyntactic.io;

import java.io.IOException;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public interface Persistable extends Serializable {
  void persistTo(PersistableOutputStream out) throws IOException;


  public interface Reader<T extends Persistable> {
    T read(PersistableInputStream in) throws IOException;

    List<T> readList(PersistableInputStream in) throws IOException;

    Set<T> readSet(PersistableInputStream in) throws IOException;
  }
}