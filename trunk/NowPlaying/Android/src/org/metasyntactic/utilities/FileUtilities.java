package org.metasyntactic.utilities;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.metasyntactic.Constants;

import java.io.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class FileUtilities {
  private FileUtilities() {

  }


  public static String sanitizeFileName(String name) {
    return name.replace("/", "-slash-");
  }


  public static void writeObject(Object o, String fileName) {
    writeObject(o, new File(fileName));
  }

  public static void writeObject(Object o, File file) {
    try {
      ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(file));
      out.writeObject(o);
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "writeObject", e);
      throw new RuntimeException(e);
    }
  }


  public static <T> T readObject(String fileName) {
    return (T)readObject(new File(fileName));
  }


  public static <T> T readObject(File file) {
    try {
      ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
      return (T) in.readObject();
    } catch (IOException e) {
      ExceptionUtilities.log(FileUtilities.class, "readObject", e);
      return null;
    } catch (ClassNotFoundException e) {
      ExceptionUtilities.log(FileUtilities.class, "readObject", e);
      throw new RuntimeException(e);
    }
  }


  public static boolean tooSoon(String fileName) {
    File file = new File(fileName);
    if (!file.exists()) {
      return false;
    }

    DateTime now = new DateTime();
    DateTime lastDate = new DateTime(file.lastModified());

    int days = Days.daysBetween(now, lastDate).getDays();
    if (days > 0) {
      // different days, so definitely out of date
      return false;
    }

    long hours = (now.getMillis() - lastDate.getMillis()) / Constants.ONE_HOUR;
    if (hours > 8) {
      return false;
    }

    return true;
  }
}
