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
package org.metasyntactic.caches;

import java.io.File;
import java.util.Date;
import java.util.List;

import org.metasyntactic.Constants;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.utilities.LogUtilities;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public abstract class AbstractCache {
  protected final Object lock = new Object();
  protected final NowPlayingModel model;
  protected boolean shutdown;

  protected AbstractCache(final NowPlayingModel model) {
    this.model = model;
  }

  public void clearStaleData() {
    for (final File directory : getCacheDirectories()) {
      clearDirectory(directory);
    }
  }

  protected abstract List<File> getCacheDirectories();

  protected static void clearDirectory(final File directory) {
    final long now = new Date().getTime();

    for (final File child : directory.listFiles()) {
      if (child.exists() && child.isFile()) {
        final long writeTime = child.lastModified();
        final long span = Math.abs(writeTime - now);

        if (span > Constants.CACHE_LIMIT) {
          child.delete();
        }
      }
    }
  }

  public void shutdown() {
    LogUtilities.i(getClass().getSimpleName(), "Received shutdown notification");
    shutdown = true;
  }

  public void onLowMemory() {
    LogUtilities.i(getClass().getSimpleName(), "Received onLowMemory notification");
  }
}
