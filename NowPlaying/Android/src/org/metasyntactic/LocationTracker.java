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

import android.content.Context;
import android.location.Criteria;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import org.metasyntactic.data.Location;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LocationUtilities;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class LocationTracker implements LocationListener {
  private final NowPlayingController controller;
  private LocationManager locationManager;

  private final Object lock = new Object();
  private boolean shutdown;

  public LocationTracker(NowPlayingController controller, Context context) {
    this.controller = controller;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

    this.autoUpdateLocation();
  }

  public void autoUpdateLocation() {
    if (controller.isAutoUpdateEnabled()) {
      Criteria criteria = new Criteria();
      criteria.setAccuracy(Criteria.ACCURACY_COARSE);
      String provider = locationManager.getBestProvider(criteria, true);
      locationManager.requestLocationUpdates(provider, 5 * 60 * 1000, 1000, this);
    }
  }

  public void shutdown() {
    shutdown = true;
    locationManager.removeUpdates(this);
  }

  public void onLocationChanged(final android.location.Location location) {
    if (location == null) {
      return;
    }

    Runnable runnable = new Runnable() {
      public void run() {
        findLocationBackgroundEntryPoint(location.getLatitude(), location.getLongitude());
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Lookup location", runnable, lock, true);
  }

  private void findLocationBackgroundEntryPoint(double latitude, double longitude) {
    final Location location = LocationUtilities.findLocation(latitude, longitude);
    if (location == null) {
      return;
    }

    Runnable runnable = new Runnable() {
      public void run() {
        reportFoundLocation(location);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportFoundLocation(Location location) {
    if (shutdown) {
      return;
    }

    String displayString = location.toDisplayString();
    controller.reportLocationForAddress(location, displayString);
    controller.setUserAddress(displayString);
  }

  public void onStatusChanged(String s, int i, Bundle bundle) {
  }

  public void onProviderEnabled(String s) {
  }

  public void onProviderDisabled(String s) {
  }
}
