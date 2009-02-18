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

import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;

public class PersistableOutputStream {
  private final OutputStream out;
  private byte[] bytes;
  private ByteBuffer byteBuffer;
  private CharBuffer charBuffer;

  private void initializeBuffers(final int byteCount) {
    this.bytes = new byte[byteCount];
    this.byteBuffer = ByteBuffer.wrap(this.bytes);
    this.charBuffer = this.byteBuffer.asCharBuffer();
  }

  public PersistableOutputStream(final OutputStream out) {
    this.out = out;
    initializeBuffers(1 << 11);
  }

  public void close() throws IOException {
    flush();
    this.out.close();
  }

  public void flush() throws IOException {
    this.out.flush();
  }

  private final byte[] bytes4 = new byte[4];
  private final byte[] bytes8 = new byte[8];
  private final ByteBuffer buffer4 = ByteBuffer.wrap(this.bytes4);
  private final ByteBuffer buffer8 = ByteBuffer.wrap(this.bytes8);

  public void writeInt(final int i) throws IOException {
    this.buffer4.putInt(0, i);
    this.out.write(this.bytes4);
  }

  public void writeLong(final long v) throws IOException {
    this.buffer8.putLong(0, v);
    this.out.write(this.bytes8);
  }

  public void writeDouble(final double d) throws IOException {
    this.buffer8.putDouble(0, d);
    this.out.write(this.bytes8);
  }

  public void writeString(final String string) throws IOException {
    final String s = StringUtilities.nonNullString(string);
    /*
     * final int charCount = s.length(); final int byteCount = charCount 2;
     * 
     * if (byteCount > this.bytes.length) {
     * initializeBuffers(Math.max(byteCount, this.bytes.length 2)); }
     * 
     * writeInt(charCount);
     * 
     * this.byteBuffer.position(0); this.charBuffer.position(0);
     * this.charBuffer.put(s);
     * 
     * this.out.write(this.bytes, 0, byteCount);
     */

    final byte[] stringBytes = s.getBytes("UTF-8");
    writeInt(stringBytes.length);
    this.out.write(stringBytes, 0, stringBytes.length);
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