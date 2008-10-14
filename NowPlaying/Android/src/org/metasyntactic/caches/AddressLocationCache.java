package org.metasyntactic.caches;

import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class AddressLocationCache {
  private AddressLocationCache() {

  }


  public static Map<Theater, Double> getTheaterDistanceMap(Location location, List<Theater> theaters) {
    Map<Theater, Double> map = new LinkedHashMap<Theater, Double>();

    for (Theater theater : theaters) {
      double d;
      if (location != null) {
        d = location.distanceTo(theater.getLocation());
      } else {
        d = Location.UNKNOWN_DISTANCE;
      }

      map.put(theater, d);
    }

    return map;
  }
}
