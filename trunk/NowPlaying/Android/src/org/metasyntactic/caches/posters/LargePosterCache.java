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
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class LargePosterCache extends AbstractCache {
  private Map<String,List<String>> index;

  public LargePosterCache(NowPlayingModel model) {
    super(model);
  }

  protected List<File> getCacheDirectories() {
    return Collections.singletonList(Application.postersLargeDirectory);
  }

  public byte[] downloadFirstPoster(Movie movie) {
    /*

    NSArray* urls = [self posterUrls:movie];
    [self downloadPosterForMovie:movie urls:urls index:0];
     */

    List<String> urls = getPosterUrls(movie);
    return downloadPosterForMovie(movie, urls, 0);
  }

  private List<String> getPosterUrls(Movie movie) {
    synchronized (lock) {
      ensureIndex();
      String result = EditDistance.findClosestMatch(movie.getCanonicalTitle(), index.keySet());
      if (isNullOrEmpty(result)) {
        return Collections.emptyList();
      }

      return index.get(result);
      /*
          [self ensureIndex];

    NSDictionary* index = self.index;

    DifferenceEngine* engine = [DifferenceEngine engine];
    NSString* title = [engine findClosestMatch:movie.canonicalTitle inArray:index.allKeys];

    if (title.length == 0) {
        return [NSArray array];
    }

    NSArray* urls = [index objectForKey:title];
    return urls;
       */
    }
  }
}
