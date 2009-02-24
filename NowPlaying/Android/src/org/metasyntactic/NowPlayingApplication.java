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
package org.metasyntactic;

import android.app.Application;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import org.metasyntactic.activities.R;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class NowPlayingApplication extends Application {
  public final static String NOW_PLAYING_CHANGED_INTENT = "NOW_PLAYING_CHANGED_INTENT";
  public final static String NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS = "NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS";
  public final static String NOW_PLAYING_LOCAL_DATA_DOWNLOADED = "NOW_PLAYING_LOCAL_DATA_DOWNLOADED";
  public final static String NOW_PLAYING_UPDATING_LOCATION_START = "NOW_PLAYING_UPDATING_LOCATION_START";
  public final static String NOW_PLAYING_UPDATING_LOCATION_STOP = "NOW_PLAYING_UPDATING_LOCATION_STOP";
  public final static String SCROLLING_INTENT = "SCROLLING_INTENT";
  public final static String NOT_SCROLLING_INTENT = "NOT_SCROLLING_INTENT";
  public final static String host =
    /*
     * "metaboxoffice6"; /
     */
    "metaboxoffice2";
  // */
  public static final File root = new File("/sdcard");
  public static final File applicationDirectory = new File(root, "NowPlaying");
  public static final File dataDirectory = new File(applicationDirectory, "Data");
  public static final File tempDirectory = new File(applicationDirectory, "Temp");
  public static final File performancesDirectory = new File(dataDirectory, "Performances");
  public static final File trailersDirectory = new File(applicationDirectory, "Trailers");
  public static final File userLocationsDirectory = new File(applicationDirectory, "UserLocations");
  public static final File scoresDirectory = new File(applicationDirectory, "Scores");
  public static final File reviewsDirectory = new File(applicationDirectory, "Reviews");
  public static final File imdbDirectory = new File(applicationDirectory, "IMDb");
  public static final File postersDirectory = new File(applicationDirectory, "Posters");
  public static final File postersLargeDirectory = new File(postersDirectory, "Large");
  public static final File upcomingDirectory = new File(applicationDirectory, "Upcoming");
  public static final File upcomingCastDirectory = new File(upcomingDirectory, "Cast");
  public static final File upcomingImdbDirectory = new File(upcomingDirectory, "IMDb");
  public static final File upcomingPostersDirectory = new File(upcomingDirectory, "Posters");
  public static final File upcomingSynopsesDirectory = new File(upcomingDirectory, "Synopses");
  public static final File upcomingTrailersDirectory = new File(upcomingDirectory, "Trailers");
  private static Pulser pulser;

  static {
    if (FileUtilities.isSDCardAccessible()) {
      createDirectories();

      final Runnable runnable = new Runnable() {
        public void run() {
          if (NowPlayingControllerWrapper.isRunning()) {
            final Context context = NowPlayingControllerWrapper.tryGetApplicationContext();
            if (context != null) {
              context.sendBroadcast(new Intent(NOW_PLAYING_CHANGED_INTENT));
            }
          }
        }
      };
      pulser = new Pulser(runnable, 5);
    }
  }

  public NowPlayingApplication() {

  }

  public static String getName(final Resources resources) {
    return resources.getString(R.string.application_name);
  }

  public static String getNameAndVersion(final Resources resources) {
    return resources.getString(R.string.application_name_and_version);
  }

  private final BroadcastReceiver unmountedReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context contextfinal, final Intent intent) {
      FileUtilities.setSDCardAccessible(false);
    }
  };

  private final BroadcastReceiver mountedReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context contextfinal, final Intent intent) {
      FileUtilities.setSDCardAccessible(true);
    }
  };

  private final BroadcastReceiver ejectReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context contextfinal, final Intent intent) {
      FileUtilities.setSDCardAccessible(true);
    }
  };

  @Override
  public void onCreate() {
    super.onCreate();
    this.registerReceiver(unmountedReceiver, new IntentFilter(Intent.ACTION_MEDIA_UNMOUNTED));
    this.registerReceiver(mountedReceiver, new IntentFilter(Intent.ACTION_MEDIA_MOUNTED));
    this.registerReceiver(ejectReceiver, new IntentFilter(Intent.ACTION_MEDIA_EJECT));
  }


  @Override
  public void onLowMemory() {
    super.onLowMemory();
    NowPlayingControllerWrapper.onLowMemory();
    FileUtilities.onLowMemory();
  }

  public static void initialize() {
  }

  private static List<File> directories() {
    try {
      final List<File> directories = new ArrayList<File>();
      for (final Field field : NowPlayingApplication.class.getFields()) {
        if (!field.getType().equals(File.class) || root.equals(field.get(null))) {
          continue;
        }
        directories.add((File) field.get(null));
      }
      return directories;
    } catch (final IllegalAccessException e) {
      throw new RuntimeException(e);
    }
  }

  public static void reset() {
    deleteDirectories();
    createDirectories();
  }

  private static void createDirectories() {
    final long start = System.currentTimeMillis();
    for (final File file : directories()) {
      file.mkdirs();
      final File nomediaFile = new File(file, ".nomedia");
      try {
        nomediaFile.createNewFile();
      } catch (final IOException e) {
        throw new RuntimeException(e);
      }
    }
    LogUtilities.logTime(NowPlayingApplication.class, "Create Directories", start);
  }

  private static void deleteDirectories() {
    final long start = System.currentTimeMillis();
    deleteDirectory(applicationDirectory);
    LogUtilities.logTime(NowPlayingApplication.class, "Delete Directories", start);
  }

  public static void deleteDirectory(final File directory) {
    deleteItem(directory);
  }

  private static void deleteItem(final File item) {
    if (!item.exists()) {
      return;
    }
    if (item.isDirectory()) {
      for (final File child : item.listFiles()) {
        deleteItem(child);
      }
    } else {
      item.delete();
    }
  }

  public static boolean useKilometers() {
    return false;
  }

  public static void refresh() {
    refresh(false);
  }

  public static void refresh(final boolean force) {
    if (ThreadingUtilities.isBackgroundThread()) {
      final Runnable runnable = new Runnable() {
        public void run() {
          refresh(force);
        }
      };
      ThreadingUtilities.performOnMainThread(runnable);
      return;
    }
    if (pulser == null) {
      return;
    }

    if (force) {
      pulser.forcePulse();
    } else {
      pulser.tryPulse();
    }
  }
}
