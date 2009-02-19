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

import java.io.DataInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.*;

public class PersistableInputStream {
  private final DataInputStream in;

  public PersistableInputStream(final DataInputStream in) {
    this.in = in;
  }

  public void close() throws IOException {
    in.close();
  }

  public int readInt() throws IOException {
    return in.readInt();
  }

  public long readLong() throws IOException {
    return in.readLong();
  }

  public double readDouble() throws IOException {
    return in.readDouble();
  }

  public String readString() throws IOException {
    return in.readUTF();
  }

  public <T extends Persistable> T readPersistable(final Persistable.Reader<T> reader) throws IOException {
    return reader.read(this);
  }

  public List<String> readStringList() throws IOException {
    final int size = readInt();
    final List<String> result = new ArrayList<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readString());
    }
    return result;
  }

  public Set<String> readStringSet() throws IOException {
    final int size = readInt();
    final Set<String> result = new HashSet<String>(size);
    for (int i = 0; i < size; i++) {
      result.add(readString());
    }
    return result;
  }

  public Date readDate() throws IOException {
    final long millis = readLong();
    if (millis == -1) {
      return null;
    }

    return new Date(millis);
  }
}
