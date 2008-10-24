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
import org.metasyntactic.time.Hours;

import java.io.*;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class FileUtilities {
  private FileUtilities() {

  }


  public static String sanitizeFileName(String name) {
    StringBuilder result = new StringBuilder();
    for (char c : name.toCharArray()) {
      if ((c >= 'a' && c <= 'z') ||
          (c >= 'A' && c <= 'Z') ||
          (c >= '0' && c <= '9') ||
          c == ' ' || c == '-' || c == '.') {
        result.append(c);
      } else {
        result.append('-');
        result.append((int) c);
        result.append('-');
      }
    }
    return result.toString();
  }

/*
  private static Object readObject(File file) {
    try {
      byte[] bytes = readBytes(file);
      ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes));
      return in.readObject();
    } catch (IOException e) {
      throw new RuntimeException(e);
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
  }


  private static void writeObject(Object o, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(file));
      out.writeObject(o);
      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
  */


  public static Map<String, Date> readStringToDateMap(File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      Map<String, Date> result = new HashMap<String, Date>();

      int size = in.readInt();
      for (int i = 0; i < size; i++) {
        String key = in.readString();
        Date value = in.readDate();

        result.put(key, value);
      }

      in.close();
      return result;
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static void writeStringToDateMap(Map<String, Date> map, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (Map.Entry<String, Date> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writeDate(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static Map<String, String> readStringToStringMap(File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      Map<String, String> result = new HashMap<String, String>();

      int size = in.readInt();
      for (int i = 0; i < size; i++) {
        String key = in.readString();
        String value = in.readString();

        result.put(key, value);
      }

      in.close();
      return result;
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static void writeStringToStringMap(Map<String, String> map, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (Map.Entry<String, String> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writeString(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> Map<String, T> readStringToPersistableMap(Persistable.Reader<T> reader,
                                                                                  File file) {
    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      int size = in.readInt();

      Map<String, T> result = new HashMap<String, T>(size);
      for (int i = 0; i < size; i++) {
        String key = in.readString();
        T value = in.readPersistable(reader);

        result.put(key, value);
      }

      in.close();

      return result;
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> void writeStringToPersistableMap(Map<String, T> map, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (Map.Entry<String, T> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writePersistable(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static List<String> readStringList(File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      List<String> result = in.readStringList();

      in.close();
      return result;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      throw new RuntimeException(e);
    }
  }


  public static void writeStringCollection(Collection<String> collection, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writeStringCollection(collection);

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      throw new RuntimeException(e);
    }
  }


  public static String readString(File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      return new String(readBytes(file), "UTF-8");
    } catch (UnsupportedEncodingException e) {
      throw new RuntimeException(e);
    }
  }


  public static void writeString(String s, File file) {
    try {
      writeBytes(s.getBytes("UTF-8"), file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeString", e);
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> T readPersistable(Persistable.Reader<T> reader, File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      T result = in.readPersistable(reader);

      in.close();
      return result;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistable", e);
      return null;
    }
  }


  public static void writePersistable(Persistable p, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
      PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writePersistable(p);

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writePersistable", e);
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> List<T> readPersistableList(Persistable.Reader<T> reader, File file) {
    if (!file.exists()) {
      return null;
    }

    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      List<T> result = reader.readList(in);

      in.close();
      return result;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readPersistableList", e);
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> void writePersistableCollection(Collection<T> collection, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
      PersistableOutputStream out = new PersistableOutputStream(byteOut);
      out.writeInt(collection.size());
      for (T t : collection) {
        out.writePersistable(t);
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writePersistableCollection", e);
      throw new RuntimeException(e);
    }
  }


  public static byte[] readBytes(File file) {
    try {
      if (!file.exists()) {
        return null;
      }

      int length = (int) file.length();

      byte[] bytes = new byte[length];
      FileInputStream in = new FileInputStream(file);

      int start = 0;
      while (true) {
        int read = in.read(bytes, start, length - start);
        if (read + start == length) {
          break;
        }

        start += read;
      }
      in.close();

      return bytes;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readBytes", e);
      return null;
    }
  }


  public static void writeBytes(byte[] data, File file) {
    try {
      if (data == null) {
        data = new byte[0];
      }

      File tempFile = Application.createTempFile();
      BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(tempFile), 1 << 13);
      out.write(data);

      out.flush();
      out.close();

      tempFile.renameTo(file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeBytes", e);
      throw new RuntimeException(e);
    }
  }


  public static boolean tooSoon(File file) {
    if (!file.exists()) {
      return false;
    }

    Date now = new Date();
    Date lastDate = new Date(file.lastModified());

    int days = Days.daysBetween(now, lastDate);
    //Debug.stopMethodTracing();

    if (days > 0) {
      return false;
    }

    long hours = Hours.hoursBetween(now, lastDate);
    if (hours > 12) {
      return false;
    }

    return true;
  }


  public static <T extends Persistable> Map<String, List<T>> readStringToListOfPersistables(
      Persistable.Reader<T> reader, File file) {
    try {
      PersistableInputStream in = new PersistableInputStream(new FileInputStream(file));
      int size = in.readInt();

      Map<String,List<T>> result = new HashMap<String, List<T>>(size);
      for (int i = 0; i < size; i++) {
        String key = in.readString();
        List<T> value = reader.readList(in);
        result.put(key, value);
      }

      in.close();
      return result;
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }


  public static <T extends Persistable> void writeStringToListOfPersistables(
      Map<String, List<T>> map, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream(1 << 13);
      PersistableOutputStream out = new PersistableOutputStream(byteOut);

      out.writeInt(map.size());
      for (Map.Entry<String, List<T>> e : map.entrySet()) {
        out.writeString(e.getKey());
        out.writePersistableCollection(e.getValue());
      }

      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}
