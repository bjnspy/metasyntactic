package org.metasyntactic;

import java.io.File;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Application {
  static {
    createDirectories();
  }


  private final static Object gate = new Object();

  public static final String rootDirectory = "/sdcard";
  public static final String applicationDirectory = new File(rootDirectory, "NowPlaying").getAbsolutePath();
  public static final String dataDirectory = new File(applicationDirectory, "Data").getAbsolutePath();
  public static final String userLocationsDirectory = new File(applicationDirectory, "UserLocations").getAbsolutePath();


  private Application() {

  }


  private static String[] directories() {
    return new String[]{
        applicationDirectory,
        dataDirectory,
        userLocationsDirectory
    };
  }


  public static void reset() {
    deleteDirectories();
    createDirectories();
  }


  private static void createDirectories() {
    for (String name : directories()) {
      new File(name).mkdirs();
    }
  }


  private static void deleteDirectories() {
    deleteItem(new File(applicationDirectory));
  }


  private static void deleteItem(File item) {
    for (File child : item.listFiles()) {
      deleteItem(child);
    }

    item.delete();
  }


  public static boolean useKilometers() {
    return false;
  }
}
