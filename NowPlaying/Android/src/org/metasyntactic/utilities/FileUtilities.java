//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
package org.metasyntactic.utilities;

import org.metasyntactic.Application;
import org.metasyntactic.io.Persistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;
import org.metasyntactic.time.Days;
import static org.metasyntactic.utilities.CollectionUtilities.nonNullCollection;
import static org.metasyntactic.utilities.CollectionUtilities.nonNullMap;

import java.io.*;
import java.util.*;

public class FileUtilities {
  private FileUtilities() {
  }

  public static int daysSinceNow(final File file) {
    final Date today = DateUtilities.getToday();
    final Date releaseDate = new Date(file.lastModified());

    return Days.daysBetween(today, releaseDate);
  }

  public static String sanitizeFileName(final String name) {
    final StringBuilder result = new StringBuilder(name.length() * 2);
    for (final char c : name.toCharArray()) {
      if (isLegalCharacter(c)) {
        result.append(c);
      } else {
        result.append('-');
        result.append((int) c);
        result.append('-');
      }
    }
    return result.toString();
  }

  private static boolean isLegalCharacter(final char c) {
    return c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || c == ' ' || c == '-' || c == '.';
  }

  public static Map<String, Date> readStringToDateMap(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final Map<String, Date> result = new HashMap<String, Date>();

      final int size = in.readInt();
      for (int i = 0; i < size; i++) {
        final String key = in.readString();
        final Date value = in.readDate();

        result.put(key, value);
      }

      in.close();
      return result;
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeStringToDateMap(Map<String, Date> map, final File file) {
    try {
      map = nonNullMap(map);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (final Map.Entry<String, Date> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writeDate(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static Map<String, String> readStringToStringMap(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final Map<String, String> result = new HashMap<String, String>();

      final int size = in.readInt();
      for (int i = 0; i < size; i++) {
        final String key = in.readString();
        final String value = in.readString();

        result.put(key, value);
      }

      in.close();
      return result;
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeStringToStringMap(Map<String, String> map, final File file) {
    try {
      map = nonNullMap(map);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (final Map.Entry<String, String> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writeString(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> Map<String, T> readStringToPersistableMap(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final int size = in.readInt();

      final Map<String, T> result = new HashMap<String, T>(size);
      for (int i = 0; i < size; i++) {
        final String key = in.readString();
        final T value = in.readPersistable(reader);

        result.put(key, value);
      }

      in.close();

      return result;
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> void writeStringToPersistableMap(Map<String, T> map, final File file) {
    try {
      map = nonNullMap(map);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (final Map.Entry<String, T> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writePersistable(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static List<String> readStringList(final File file) {
    if (!file.exists()) {
      return Collections.emptyList();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final List<String> result = in.readStringList();

      in.close();
      return result;
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      throw new RuntimeException(e);
    }
  }

  public static void writeStringCollection(Collection<String> collection, final File file) {
    try {
      collection = nonNullCollection(collection);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writeStringCollection(collection);

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      throw new RuntimeException(e);
    }
  }

  public static String readString(final File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      return new String(readBytes(file), "UTF-8");
    } catch (final UnsupportedEncodingException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeString(final String s, final File file) {
    try {
      writeBytes(s.getBytes("UTF-8"), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeString", e);
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> T readPersistable(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final T result = in.readPersistable(reader);

      in.close();
      return result;
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      return null;
    }
  }

  public static void writePersistable(final Persistable p, final File file) {
    try {
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writePersistable(p);

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writePersistable", e);
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> List<T> readPersistableList(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyList();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final List<T> result = reader.readList(in);

      in.close();
      return result;
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistableList", e);
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> void writePersistableCollection(Collection<T> collection, final File file) {
    try {
      collection = nonNullCollection(collection);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writeInt(collection.size());
      for (final T t : collection) {
        out.writePersistable(t);
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writePersistableCollection", e);
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> Map<String, List<T>> readStringToListOfPersistables(final Persistable.Reader<T> reader, final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final int size = in.readInt();

      final Map<String, List<T>> result = new HashMap<String, List<T>>(size);
      for (int i = 0; i < size; i++) {
        final String key = in.readString();
        final List<T> value = reader.readList(in);
        result.put(key, value);
      }

      in.close();
      return result;
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static <T extends Persistable> void writeStringToListOfPersistables(Map<String, List<T>> map, final File file) {
    try {
      map = nonNullMap(map);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (final Map.Entry<String, List<T>> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writePersistableCollection(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static Map<String, List<String>> readStringToListOfStrings(final File file) {
    if (!file.exists()) {
      return Collections.emptyMap();
    }

    try {
      final PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      final int size = in.readInt();

      final Map<String, List<String>> result = new HashMap<String, List<String>>(size);
      for (int i = 0; i < size; i++) {
        final String key = in.readString();
        final List<String> value = in.readStringList();
        result.put(key, value);
      }

      in.close();
      return result;
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static void writeStringToListOfStrings(Map<String, List<String>> map, final File file) {
    try {
      map = nonNullMap(map);
      final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      final PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (final Map.Entry<String, List<String>> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writeStringCollection(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
  }

  public static byte[] readBytes(final File file) {
    if (!file.exists()) {
      return new byte[0];
    }

    try {
      final int length = (int) file.length();

      final byte[] bytes = new byte[length];
      final FileInputStream in = new FileInputStream(file);

      int start = 0;
      while (true) {
        final int read = in.read(bytes, start, length - start);
        if (read + start == length) {
          break;
        }

        start += read;
      }
      in.close();

      return bytes;
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readBytes", e);
      return null;
    }
  }

  public static void writeBytes(byte[] data, final File file) {
    try {
      if (data == null) {
        data = new byte[0];
      }

      final File tempFile = Application.createTempFile();
      final BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(tempFile), 1 << 13);
      out.write(data);

      out.flush();
      out.close();

      tempFile.renameTo(file);
    } catch (final IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeBytes", e);
      throw new RuntimeException(e);
    }
  }
}
