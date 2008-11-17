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
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.util.*;

public class PersistableInputStream {
  private final InputStream in;

  public PersistableInputStream(final InputStream in) {
    this.in = in;
    initializeBuffers(1 << 11);
  }

  public void close() throws IOException {
    this.in.close();
  }

  private void readEntireArray(final byte[] bytes) throws IOException {
    int position = 0;

    while (true) {
      final int read = this.in.read(bytes, position, bytes.length - position);
      if (read + position == bytes.length) {
        break;
      }

      position += read;
    }
  }

  private final byte[] bytes4 = new byte[4];
  private final byte[] bytes8 = new byte[8];
  private final ByteBuffer buffer4 = ByteBuffer.wrap(this.bytes4);
  private final ByteBuffer buffer8 = ByteBuffer.wrap(this.bytes8);

  public int readInt() throws IOException {
    readEntireArray(this.bytes4);
    return this.buffer4.getInt(0);
  }

  public long readLong() throws IOException {
    readEntireArray(this.bytes8);
    return this.buffer8.getLong(0);
  }

  public double readDouble() throws IOException {
    readEntireArray(this.bytes8);
    return this.buffer8.getDouble(0);
  }

  private char[] chars;
  private byte[] bytes;

  private ByteBuffer byteBuffer;
  private CharBuffer charBuffer;

  private void initializeBuffers(final int byteCount) {
    this.bytes = new byte[byteCount];
    this.chars = new char[byteCount / 2];

    this.byteBuffer = ByteBuffer.wrap(this.bytes);
    this.charBuffer = this.byteBuffer.asCharBuffer();
  }

  public String readString() throws IOException {
    final int charCount = readInt();
    final int byteCount = charCount * 2;

    if (byteCount > this.bytes.length) {
      initializeBuffers(Math.max(byteCount, this.bytes.length * 2));
    }

    this.in.read(this.bytes, 0, byteCount);

    this.byteBuffer.position(0);
    this.charBuffer.position(0);

    this.charBuffer.get(this.chars, 0, charCount);

    return new String(this.chars, 0, charCount);
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
