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
package org.metasyntactic.caches.posters;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import static org.apache.commons.collections.CollectionUtils.size;
import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.CollectionUtilities;
import static org.metasyntactic.utilities.CollectionUtilities.isEmpty;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class LargePosterCache extends AbstractCache {
  private static final int START_YEAR = 1912;
  private final Map<Integer, Map<String, List<String>>> yearToMovieMap = new HashMap<Integer, Map<String, List<String>>>();
  private final Object yearToMovieMapLock = new Object();

  public LargePosterCache(final NowPlayingModel model) {
    super(model);

    ThreadingUtilities.performOnBackgroundThread("Update large poster indices", new Runnable() {
      public void run() {
        updateIndices();
      }
    }, null, false);
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Collections.singletonList(Application.postersLargeDirectory);
  }

  public static File getIndexFile(final int year) {
    return new File(Application.postersLargeDirectory, year + ".index");
  }

  private static Map<String, List<String>> ensureIndexWorker(final int year, final boolean updateIfStale) {
    final File file = getIndexFile(year);
    if (file.exists()) {
      if (!updateIfStale) {
        return null;
      }

      if (FileUtilities.daysSinceNow(file) < 7) {
        return null;
      }
    }

    final String address = "http://" + Application.host + ".appspot.com/LookupPosterListings?provider=imp&year=" + year;
    final String result = NetworkUtilities.downloadString(address, false);

    if (StringUtilities.isNullOrEmpty(result)) {
      return null;
    }

    final Map<String, List<String>> index = new HashMap<String, List<String>>();
    for (final String row : result.split("\n")) {
      final String[] columns = row.split("\t");
      if (columns.length < 2) {
        continue;
      }

      final String movie = columns[0];
      final ArrayList<String> posters = new ArrayList<String>(columns.length - 1);
      for (int i = 1; i < columns.length; i++) {
        posters.add(columns[i]);
      }

      index.put(movie.toLowerCase(), posters);
    }

    if (!index.isEmpty()) {
      FileUtilities.writeStringToListOfStrings(index, file);
    }

    return index;
  }

  private void ensureIndex(final int year, final boolean updateIfStale) {
    Map<String, List<String>> index = ensureIndexWorker(year, updateIfStale);
    if (index == null) {
      index = FileUtilities.readStringToListOfStrings(getIndexFile(year));
    }

    if (!isEmpty(index)) {
      synchronized (this.yearToMovieMapLock) {
        this.yearToMovieMap.put(year, index);
      }
    }
  }

  private static int getYearForDate(final Date date) {
    final Calendar c = Calendar.getInstance();
    c.setTime(date);
    return c.get(Calendar.YEAR);
  }

  private static int getCurrentYear() {
    return getYearForDate(new Date());
  }

  private void updateIndices() {
    final int currentYear = getCurrentYear();
    for (int year = currentYear + 1; year >= START_YEAR; year--) {
      ensureIndex(year, year >= currentYear - 1 || year <= currentYear + 1);
    }
  }

  private List<String> getPosterNames(final Movie movie, final int year) {
    final Map<String, List<String>> index;
    synchronized (this.yearToMovieMapLock) {
      index = this.yearToMovieMap.get(year);
    }

    if (index != null) {
      final List<String> result = index.get(movie.getCanonicalTitle());
      if (!CollectionUtilities.isEmpty(result)) {
        return result;
      }

      final String lowercaseTitle = movie.getCanonicalTitle().toLowerCase();
      for (final String key : index.keySet()) {
        if (EditDistance.substringSimilar(key, lowercaseTitle)) {
          return index.get(key);
        }
      }
    }
    return Collections.emptyList();
  }

  private List<String> getPosterUrls(final Movie movie, final int year) {
    final List<String> names = getPosterNames(movie, year);
    if (CollectionUtilities.isEmpty(names)) {
      return Collections.emptyList();
    }

    final List<String> urls = new ArrayList<String>();
    for (final String name : names) {
      urls.add("http://www.impawards.com/" + year + "/posters/" + name);
    }

    return urls;
  }

  private List<String> getPosterUrlsWorker(final Movie movie) {
    final Date date = movie.getReleaseDate();
    if (date != null) {
      final int releaseYear = getYearForDate(date);

      List<String> result;
      if (size(result = getPosterUrls(movie, releaseYear)) > 0 || size(
          result = getPosterUrls(movie, releaseYear - 1)) > 0 || size(
          result = getPosterUrls(movie, releaseYear - 2)) > 0 || size(
          result = getPosterUrls(movie, releaseYear + 1)) > 0 || size(
          result = getPosterUrls(movie, releaseYear + 2)) > 0) {
        return result;
      }
    } else {
      for (int year = getCurrentYear() + 1; year >= START_YEAR; year--) {
        final List<String> result = getPosterUrls(movie, year);
        if (size(result) > 0) {
          return result;
        }
      }
    }

    return Collections.emptyList();
  }

  private List<String> getPosterUrls(final Movie movie) {
    synchronized (this.lock) {
      return getPosterUrlsWorker(movie);
    }
  }

  public void downloadFirstPoster(final Movie movie) {
    final List<String> urls = getPosterUrls(movie);
    downloadPosterForMovie(movie, urls, 0);
  }

  private static File posterFile(final Movie movie, final int index) {
    return new File(Application.postersLargeDirectory,
                    FileUtilities.sanitizeFileName(movie.getCanonicalTitle() + "-" + index + ".jpg"));
  }

  private static void downloadPosterForMovie(final Movie movie, final List<String> urls, final int index) {
    if (urls == null || index < 0 || index >= urls.size()) {
      return;
    }

    final File file = posterFile(movie, index);
    if (file.exists()) {
      return;
    }

    byte[] bytes = NetworkUtilities.download(urls.get(index), false);
    if (bytes != null) {
      bytes = resizePoster(bytes);
      FileUtilities.writeBytes(bytes, file);
      Application.refresh();
    }
  }

  private final static int MAX_DIMENSION = 240;

  private static byte[] resizePoster(final byte[] bytes) {
    final BitmapFactory.Options options1 = new BitmapFactory.Options();
    options1.inJustDecodeBounds = true;
    BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options1);

    final int width = options1.outWidth;
    final int height = options1.outHeight;

    if (height <= MAX_DIMENSION && width <= MAX_DIMENSION) {
      return bytes;
    }

    double scale = 0.0;
    if (height > width) {
      // portrait
      scale = (double)height / MAX_DIMENSION;
    } else {
      // landscape
      scale = (double)width / MAX_DIMENSION;
    }

    final BitmapFactory.Options options2 = new BitmapFactory.Options();
    options2.inPreferredConfig = Bitmap.Config.ARGB_8888;
    options2.inSampleSize = (int) scale;
    Bitmap scaledBitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options2);
    // This will give us a scaled bitmap, but still not resized to the dimensions
    // that we want.

    scaledBitmap = Bitmap.createScaledBitmap(scaledBitmap, (int) (width / scale), (int) (height / scale), true);
    final ByteArrayOutputStream byteOut = new ByteArrayOutputStream(bytes.length);
    scaledBitmap.compress(Bitmap.CompressFormat.JPEG, 90, byteOut);

    try {
      byteOut.flush();
      byteOut.close();
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }

    return byteOut.toByteArray();
  }

  public static byte[] getPoster(final Movie movie) {
    return FileUtilities.readBytes(posterFile(movie, 0));
  }

  public static File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return posterFile(movie, 0);
  }
}
