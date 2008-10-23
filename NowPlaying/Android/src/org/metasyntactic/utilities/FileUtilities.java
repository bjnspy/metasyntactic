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

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.metasyntactic.Application;
import org.metasyntactic.Constants;

import java.io.*;

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
        result.append("-" + (int) c + "-");
      }
    }
    return result.toString();
  }

/*
  public static void writeObject(Object o, String fileName) {
    writeObject(o, new File(fileName));
  }
*/


  public static void writeObject(Object o, File file) {
    try {
      ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
      ObjectOutputStream out = new ObjectOutputStream(byteOut);
      out.writeObject(o);
      out.flush();
      out.close();

      writeBytes(byteOut.toByteArray(), file);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeObject", e);
      throw new RuntimeException(e);
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
      ExceptionUtilities.log(FileUtilities.class, "writeObject", e);
      throw new RuntimeException(e);
    }
  }

/*
  public static <T> T readObject(String fileName) {
    return (T) readObject(fileName, null);
  }


  public static <T> T readObject(String fileName, T default_) {
    return readObject(new File(fileName), default_);
  }
*/


  public static <T> T readObject(File file) {
    return readObject(file, null);
  }


  public static <T> T readObject(File file, T default_) {
    try {
      byte[] bytes = readBytes(file);
      if (bytes == null) {
        return default_;
      }

      ObjectInputStream in = new ObjectInputStream(new ByteArrayInputStream(bytes));
      T result = (T) in.readObject();
      in.close();
      return result;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readObject", e);
      return default_;
    } catch (ClassNotFoundException e) {
      ExceptionUtilities.log(FileUtilities.class, "readObject", e);
      throw new RuntimeException(e);
    }
  }


  public static byte[] readBytes(File file) {
    try {
      if (!file.exists()) {
        return null;
      }

      byte[] bytes = new byte[(int)file.length()];
      FileInputStream in = new FileInputStream(file);
      in.read(bytes);
      in.close();

      return bytes;
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readObject", e);
      return null;
    }
  }


  public static boolean tooSoon(File file) {
    if (!file.exists()) {
      return false;
    }

    DateTime now = new DateTime();
    DateTime lastDate = new DateTime(file.lastModified());

    int days = Days.daysBetween(now, lastDate).getDays();
    //Debug.stopMethodTracing();

    if (days > 0) {
      return false;
    }

    long hours = (now.getMillis() - lastDate.getMillis()) / Constants.ONE_HOUR;
    if (hours > 12) {
      return false;
    }

    return true;
  }
}
