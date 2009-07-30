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
package org.metasyntactic.activities;

import java.util.LinkedHashMap;
import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.RefreshableContext;
import org.metasyntactic.services.NowPlayingService;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;

public class ActivityCore<T extends Activity & RefreshableContext> {
  private final T context;

  private final BroadcastReceiver locationNotFoundBroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      showLocationNotFoundDialog(ActivityCore.this.context);
    }
  };

  public static void showLocationNotFoundDialog(final Context context) {
    new AlertDialog.Builder(context).setMessage(R.string.could_not_find_location_dot)
    .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialogInterface, final int i) {
        //dialogInterface.dismiss()
      }
    }).show();
  }

  protected ActivityCore(final T context) {
    this.context = context;
  }

  public void onCreate() {    
  }

  public void onResume() {
    context.registerReceiver(locationNotFoundBroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_COULD_COULD_NOT_FIND_LOCATION_INTENT));
  }

  public void onPause() {
    context.unregisterReceiver(locationNotFoundBroadcastReceiver);
  }
  
  public void onDestroy() {
    
  }

  public Map<String, Object> onRetainNonConfigurationInstance() {
    return new LinkedHashMap<String, Object>();
  }

  public NowPlayingService getService() {
    return NowPlayingApplication.getService();
  }

  public Context getContext() {
    return context;
  }
}
