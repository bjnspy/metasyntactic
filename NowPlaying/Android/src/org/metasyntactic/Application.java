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

package org.metasyntactic;

import org.metasyntactic.threading.ThreadingUtilities;

import java.io.File;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Application {
  public static final String rootDirectory = "/sdcard";
  public static final String applicationDirectory = new File(rootDirectory, "NowPlaying").getAbsolutePath();
  public static final String dataDirectory = new File(applicationDirectory, "Data").getAbsolutePath();
  public static final String performancesDirectory = new File(dataDirectory, "Performances").getAbsolutePath();
  public static final String trailersDirectory = new File(applicationDirectory, "Trailers").getAbsolutePath();
  public static final String userLocationsDirectory = new File(applicationDirectory, "UserLocations").getAbsolutePath();
  public static final String tempDirectory = new File(applicationDirectory, "Temp").getAbsolutePath();
  public static final String ratingsDirectory = new File(applicationDirectory, "Ratings").getAbsolutePath();
  public static final String imdbDirectory = new File(applicationDirectory, "IMDb").getAbsolutePath();

  private static Pulser pulser;


  static {
    deleteItem(new File(tempDirectory));
    createDirectories();

    Runnable runnable = new Runnable() {
      public void run() {

      }
    };
    pulser = new Pulser(runnable, 5000);
  }


  private Application() {

  }


  private static String[] directories() {
    return new String[]{
        applicationDirectory,
        tempDirectory,
        dataDirectory,
        performancesDirectory,
        trailersDirectory,
        userLocationsDirectory,
        imdbDirectory,
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
    deleteDirectory(applicationDirectory);
  }


  public static void deleteDirectory(String directory) {
    deleteItem(new File(directory));
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


  public static void refresh() {
    refresh(false);
  }


  public static void refresh(final boolean force) {
    if (ThreadingUtilities.isBackgroundThread()) {
      Runnable runnable = new Runnable() {
        public void run() { refresh(force); }
      };
      ThreadingUtilities.performOnMainThread(runnable);
      return;
    }

    if (force) {
      pulser.forcePulse();
    } else {
      pulser.tryPulse();
    }
  }
}
