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

import org.metasyntactic.utilities.StringUtilities;

import java.io.DataOutputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;

public class PersistableOutputStream {
  private final DataOutputStream out;

  public PersistableOutputStream(final DataOutputStream out) {
    this.out = out;
  }

  public void close() throws IOException {
    flush();
    out.close();
  }

  public void flush() throws IOException {
    out.flush();
  }


  public void writeInt(final int i) throws IOException {
    out.writeInt(i);
  }

  public void writeLong(final long v) throws IOException {
    out.writeLong(v);
  }

  public void writeDouble(final double d) throws IOException {
    out.writeDouble(d);
  }

  public void writeString(final String string) throws IOException {
    final String s = StringUtilities.nonNullString(string);
    out.writeUTF(string);
  }

  public void writePersistable(final Persistable persistable) throws IOException {
    persistable.persistTo(this);
  }

  public <T extends Persistable> void writePersistableCollection(Collection<T> collection) throws IOException {
    if (collection == null) {
      collection = Collections.emptySet();
    }

    writeInt(collection.size());
    for (final T t : collection) {
      writePersistable(t);
    }
  }

  public void writeStringCollection(Collection<String> collection) throws IOException {
    if (collection == null) {
      collection = Collections.emptySet();
    }

    writeInt(collection.size());
    for (final String string : collection) {
      writeString(string);
    }
  }

  public void writeDate(final Date date) throws IOException {
    if (date == null) {
      writeLong(-1);
    } else {
      writeLong(date.getTime());
    }
  }
}