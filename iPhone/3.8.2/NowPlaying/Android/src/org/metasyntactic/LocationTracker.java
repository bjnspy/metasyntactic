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

import org.metasyntactic.data.Location;
import org.metasyntactic.services.NowPlayingService;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LocationUtilities;

import android.content.Context;
import android.content.Intent;
import android.location.Criteria;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

/**
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class LocationTracker implements LocationListener {
  private final NowPlayingService service;
  private final LocationManager locationManager;
  private final Object lock = new Object();
  private boolean shutdown;

  public LocationTracker(final NowPlayingService service) {
    this.service = service;
    locationManager = (LocationManager)NowPlayingApplication.getApplication().getSystemService(Context.LOCATION_SERVICE);
    autoUpdateLocation();
  }

  private void autoUpdateLocation() {
    if (service.isAutoUpdateEnabled()) {
      final Criteria criteria = new Criteria();
      criteria.setAccuracy(Criteria.ACCURACY_COARSE);
      final String provider = locationManager.getBestProvider(criteria, true);
      if (provider != null) {
        NowPlayingApplication.getApplication().sendBroadcast(new Intent(NowPlayingApplication.NOW_PLAYING_UPDATING_LOCATION_START));
        locationManager.requestLocationUpdates(provider, 5 * 60 * 1000, 1000, this);
      }
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
    final Runnable runnable = new Runnable() {
      public void run() {
        findLocationBackgroundEntryPoint(location.getLatitude(), location.getLongitude());
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Lookup location", runnable, lock, true);
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
    if (shutdown) {
      return;
    }
    NowPlayingApplication.getApplication().sendBroadcast(new Intent(NowPlayingApplication.NOW_PLAYING_UPDATING_LOCATION_STOP));

    final String displayString = location.toDisplayString();
    NowPlayingService.reportLocationForAddress(location, displayString);
    service.setUserAddress(displayString);
  }

  public void onStatusChanged(final String s, final int i, final Bundle bundle) {
  }

  public void onProviderEnabled(final String s) {
  }

  public void onProviderDisabled(final String s) {
  }
}
