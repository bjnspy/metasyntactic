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
package org.metasyntactic.caches;

import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class AddressLocationCache {
  private AddressLocationCache() {
  }

  public static Map<Theater, Double> getTheaterDistanceMap(final Location location, final List<Theater> theaters) {
    final Map<Theater, Double> map = new HashMap<Theater, Double>();

    for (final Theater theater : theaters) {
      final double d;
      if (location == null) {
        d = Location.UNKNOWN_DISTANCE;
      } else {
        d = location.distanceTo(theater.getLocation());
      }

      map.put(theater, d);
    }

    return map;
  }
}
