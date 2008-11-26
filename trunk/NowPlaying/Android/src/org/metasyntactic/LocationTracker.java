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
  private final LocationManager locationManager;

  private final Object lock = new Object();
  private boolean shutdown;

  public LocationTracker(final NowPlayingController controller, final Context context) {
    this.controller = controller;
    this.locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

    autoUpdateLocation();
  }

  private void autoUpdateLocation() {
    if (this.controller.isAutoUpdateEnabled()) {
      final Criteria criteria = new Criteria();
      criteria.setAccuracy(Criteria.ACCURACY_COARSE);
      final String provider = this.locationManager.getBestProvider(criteria, true);
      this.locationManager.requestLocationUpdates(provider, 5 * 60 * 1000, 1000, this);
    }
  }

  public void shutdown() {
    this.shutdown = true;
    this.locationManager.removeUpdates(this);
  }

  public void onLocationChanged(final android.location.Location location) {
    if (location == null) {
      return;
    }

    final Runnable runnable = new Runnable() {
      public void run() {
        findLocationBackgroundEntryPoint(location.getLatitude(), location.getLongitude());
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Lookup location", runnable, this.lock, true);
  }

  private void findLocationBackgroundEntryPoint(final double latitude, final double longitude) {
    final Location location = LocationUtilities.findLocation(latitude, longitude);
    if (location == null) {
      return;
    }

    final Runnable runnable = new Runnable() {
      public void run() {
        reportFoundLocation(location);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportFoundLocation(final Location location) {
    if (this.shutdown) {
      return;
    }

    final String displayString = location.toDisplayString();
    this.controller.reportLocationForAddress(location, displayString);
    this.controller.setUserAddress(displayString);
  }

  public void onStatusChanged(final String s, final int i, final Bundle bundle) {
  }

  public void onProviderEnabled(final String s) {
  }

  public void onProviderDisabled(final String s) {
  }
}
