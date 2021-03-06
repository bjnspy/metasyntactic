// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package org.metasyntactic.io;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public abstract class AbstractPersistable implements Persistable {
  /**
   *
   */
  private static final long serialVersionUID = 5436462848902430842L;

  public abstract static class AbstractReader<T extends Persistable> implements Reader<T> {
    public List<T> readList(final PersistableInputStream in) throws IOException {
      final int count = in.readInt();
      final List<T> list = new ArrayList<T>(count);
      for (int i = 0; i < count; i++) {
        list.add(read(in));
      }
      return list;
    }

    public Set<T> readSet(final PersistableInputStream in) throws IOException {
      final int count = in.readInt();
      final Set<T> set = new HashSet<T>(count);
      for (int i = 0; i < count; i++) {
        set.add(read(in));
      }
      return set;
    }
  }
}
