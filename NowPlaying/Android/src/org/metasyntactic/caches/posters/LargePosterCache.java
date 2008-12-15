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

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.AbstractCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class LargePosterCache extends AbstractCache {
  private Map<String,List<String>> index;

  public LargePosterCache(NowPlayingModel model) {
    super(model);
  }

  protected List<File> getCacheDirectories() {
    return Collections.singletonList(Application.postersLargeDirectory);
  }

  public File getIndexFile() {
    return new File(Application.postersLargeDirectory, "Index");
  }

  public void downloadFirstPoster(Movie movie) {
    List<String> urls = getPosterUrls(movie);
    downloadPosterForMovie(movie, urls, 0);
  }

  private File posterFile(Movie movie, int index) {
    
  }

  private void downloadPosterForMovie(Movie movie, List<String> urls, int index) {
    if (urls == null || index < 0 || index > urls.size()) {
      return;
    }

    File path = posterFile(movie, index);
    if (path.exists()) {
      return;
    }


    /*
        NSData* data = [NetworkUtilities dataWithContentsOfAddress:[urls objectAtIndex:index]
                                                     important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
        [NowPlayingAppDelegate minorRefresh];
    }
     */
  }

  private List<String> getPosterUrls(Movie movie) {
    synchronized (lock) {
      ensureIndex();
      String result = EditDistance.findClosestMatch(movie.getCanonicalTitle(), index.keySet());
      if (isNullOrEmpty(result)) {
        return Collections.emptyList();
      }

      return index.get(result);
    }
  }

  private void ensureIndex() {
    File indexFile = getIndexFile();

    if (indexFile.exists()) {
      if (FileUtilities.daysSinceNow(getIndexFile()) < 7) {
        return;
      }
    }

    String address = "http://" + Application.host + ".appspot.com/LookupPosterListings?provider=imp";
    String rows = NetworkUtilities.downloadString(address, false);
    if (isNullOrEmpty(rows)) {
      return;
    }

    Map<String,List<String>> map = new LinkedHashMap<String, List<String>>();

    for (String row : rows.split("\n")) {
      String[] columns = row.split("\t");
      if (columns.length < 2) {
        continue;
      }

      List<String> posters = Arrays.asList(columns).subList(1, columns.length);
      map.put(columns[0], posters);
    }

    if (map.size() > 0) {
      FileUtilities.writeStringToListOfStrings(map, indexFile);
      this.index = map;
    }
  }
}
