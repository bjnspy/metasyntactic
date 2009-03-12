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
import org.metasyntactic.services.INowPlayingService;
import org.metasyntactic.services.NowPlayingService;
import org.metasyntactic.services.NowPlayingServiceWrapper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.IBinder;

public class ActivityCore<T extends Activity & RefreshableContext> {
  private static final String SERVICE_KEY = AbstractNowPlayingActivity.class.getSimpleName() + ".service";
  private static final String CONNECTION_KEY = AbstractNowPlayingActivity.class.getSimpleName() + ".connection";

  private final T context;
  protected NowPlayingServiceWrapper service;
  private ServiceConnection connection;
  private boolean dontUnbindServiceInDestroy;

  private final BroadcastReceiver locationNotFoundBroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      showLocationNotFoundDialog(ActivityCore.this.context);
    }
  };

  public static void showLocationNotFoundDialog(final Context context) {
    new AlertDialog.Builder(context).setMessage(R.string.could_not_find_location_dot)
    .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialogInterface, final int i) {
      }
    }).show();
  }

  protected ActivityCore(final T context) {
    this.context = context;
  }

  private void bindNowPlayingService() {
    connection = new ServiceConnection() {
      public void onServiceConnected(final ComponentName componentName, final IBinder binder) {
        service = new NowPlayingServiceWrapper(INowPlayingService.Stub.asInterface(binder));
        context.onCreateAfterServiceConnected();
        context.onResumeAfterServiceConnected();
      }

      public void onServiceDisconnected(final ComponentName componentName) {
        service = null;
      }
    };

    NowPlayingApplication.getApplication().bindService(new Intent(context.getContext(), NowPlayingService.class), connection, Context.BIND_AUTO_CREATE);
  }

  public void onCreate() {
    @SuppressWarnings({"unchecked"})
    final Map<String, Object> state = (Map<String, Object>)context.getLastNonConfigurationInstance();
    if (state != null) {
      connection = (ServiceConnection)state.get(CONNECTION_KEY);
      service = (NowPlayingServiceWrapper) state.get(SERVICE_KEY);
      context.onCreateAfterServiceConnected();
    } else {
      bindNowPlayingService();
    }
  }

  public void onResume() {
    context.registerReceiver(locationNotFoundBroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_COULD_COULD_NOT_FIND_LOCATION_INTENT));

    if (service != null) {
      context.onResumeAfterServiceConnected();
    }
  }

  public void onPause() {
    context.unregisterReceiver(locationNotFoundBroadcastReceiver);
  }

  protected void onDestroy() {
    if (!dontUnbindServiceInDestroy) {
      NowPlayingApplication.getApplication().unbindService(connection);
    }
    dontUnbindServiceInDestroy = false;
  }

  public Map<String, Object> onRetainNonConfigurationInstance() {
    dontUnbindServiceInDestroy = true;

    final Map<String, Object> state = new LinkedHashMap<String, Object>();
    state.put(SERVICE_KEY, service);
    state.put(CONNECTION_KEY, connection);
    return state;
  }

  public NowPlayingServiceWrapper getService() {
    return service;
  }

  public Context getContext() {
    return context;
  }
}
