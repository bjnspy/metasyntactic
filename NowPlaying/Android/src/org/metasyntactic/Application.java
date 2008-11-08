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

import android.content.Context;
import android.content.Intent;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LogUtilities;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class Application {
  public final static String NOW_PLAYING_CHANGED_INTENT = "NowPlayingModelChangedIntent";

  public final static String host =
      //*
      "metaboxoffice6";
  /*/
  	"metaboxoffice2";
  //*/

  public static final File root = new File("/sdcard");
  public static final File applicationDirectory = new File(root, "NowPlaying");
  public static final File dataDirectory = new File(applicationDirectory, "Data");
  public static final File performancesDirectory = new File(dataDirectory, "Performances");
  public static final File trailersDirectory = new File(applicationDirectory, "Trailers");
  public static final File userLocationsDirectory = new File(applicationDirectory, "UserLocations");
  public static final File tempDirectory = new File(applicationDirectory, "Temp");
  public static final File scoresDirectory = new File(applicationDirectory, "Scores");
  public static final File reviewsDirectory = new File(applicationDirectory, "Reviews");
  public static final File imdbDirectory = new File(applicationDirectory, "IMDb");
  public static final File postersDirectory = new File(applicationDirectory, "Posters");

  public static final File upcomingDirectory = new File(applicationDirectory, "Upcoming");
  public static final File upcomingCastDirectory = new File(upcomingDirectory, "Cast");
  public static final File upcomingImdbDirectory = new File(upcomingDirectory, "IMDb");
  public static final File upcomingPostersDirectory = new File(upcomingDirectory, "Posters");
  public static final File upcomingSynopsesDirectory = new File(upcomingDirectory, "Synopses");
  public static final File upcomingTrailersDirectory = new File(upcomingDirectory, "Trailers");

  private static Pulser pulser;
  private static Context context;

  static {
    createDirectories();

    Runnable runnable = new Runnable() {
      public void run() {
        if (context != null) {
          context.sendBroadcast(new Intent(NOW_PLAYING_CHANGED_INTENT));
        }
      }
    };
    pulser = new Pulser(runnable, 5);
  }

  private Application() {

  }

  private static List<File> directories() {
    try {
      List<File> directories = new ArrayList<File>();

      for (Field field : Application.class.getFields()) {
        if (field.getType() != File.class || field.get(null) == root) {
          continue;
        }

        directories.add((File) field.get(null));
      }

      return directories;
    } catch (IllegalAccessException e) {
      throw new RuntimeException(e);
    }
  }

  public static void reset() {
    deleteDirectories();
    createDirectories();
  }

  private static void createDirectories() {
    long start = System.currentTimeMillis();
    for (File file : directories()) {
      file.mkdirs();
    }
    LogUtilities.logTime(Application.class, "Create Directories", start);
  }

  private static void deleteDirectories() {
    long start = System.currentTimeMillis();
    deleteDirectory(applicationDirectory);
    LogUtilities.logTime(Application.class, "Delete Directories", start);
  }

  public static void deleteDirectory(File directory) {
    deleteItem(directory);
  }

  private static void deleteItem(File item) {
    if (!item.exists()) {
      return;
    }

    if (item.isDirectory()) {
      for (File child : item.listFiles()) {
        deleteItem(child);
      }
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

  public static void setContext(Context context) {
    Application.context = context;
  }

  public static File createTempFile() {
    try {
      return File.createTempFile("NPTF", null, tempDirectory);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}
