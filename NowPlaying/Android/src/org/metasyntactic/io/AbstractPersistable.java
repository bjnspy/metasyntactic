package org.metasyntactic.io;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public abstract class AbstractPersistable implements Persistable {
  public static abstract class AbstractReader<T extends Persistable> implements Reader<T> {
    public List<T> readList(PersistableInputStream in) throws IOException {
      int count = in.readInt();
      List<T> list = new ArrayList<T>(count);
      for (int i = 0; i < count; i++) {
        list.add(read(in));
      }
      return list;
    }


    public Set<T> readSet(PersistableInputStream in) throws IOException {
      int count = in.readInt();
      Set<T> set = new HashSet<T>(count);
      for (int i = 0; i < count; i++) {
        set.add(read(in));
      }
      return set;
    }
  }
}
