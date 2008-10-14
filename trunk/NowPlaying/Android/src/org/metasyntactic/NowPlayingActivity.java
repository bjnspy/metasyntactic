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

package org.metasyntactic;

import org.metasyntactic.views.AllMoviesView;
import org.metasyntactic.views.AllTheatersView;
import org.metasyntactic.views.UpcomingMoviesView;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.view.View;
import android.widget.TabHost;

public class NowPlayingActivity extends Activity {
  private NowPlayingControllerWrapper controller;
  private AllMoviesView allMoviesView;
  private AllTheatersView allTheatersView;
  private UpcomingMoviesView upcomingMoviesView;

  private final BroadcastReceiver broadcastReceiver =
      new BroadcastReceiver() {
        @Override
				public void onReceive(Context context, Intent intent) {
          refresh();
        }
      };


  private final ServiceConnection serviceConnection =
      new ServiceConnection() {
        public void onServiceConnected(ComponentName className, IBinder service) {
          // This is called when the connection with the service has been
          // established, giving us the service object we can use to
          // interact with the service.  We are communicating with our
          // service through an IDL interface, so get a client-side
          // representation of that from the raw service object.
          controller = new NowPlayingControllerWrapper(INowPlayingController.Stub.asInterface(service));
          onControllerConnected();
        }


        public void onServiceDisconnected(ComponentName className) {
          controller = null;
        }
      };


  private void onControllerConnected() {
    int selectedTab = controller.getSelectedTabIndex();
    getTabHost().setCurrentTab(selectedTab);
  }


  private TabHost getTabHost() {
    return (TabHost) findViewById(R.id.tab_host);
  }


  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.tabs);

    boolean bindResult = bindService(
        new Intent(getBaseContext(), NowPlayingControllerService.class),
        serviceConnection,
        Context.BIND_AUTO_CREATE);

    if (!bindResult) {
      throw new RuntimeException("Failed to bind to service!");
    }

    final TabHost tabs = getTabHost();
    tabs.setup();

    allMoviesView = new AllMoviesView(this);
    allTheatersView = new AllTheatersView(this);
    upcomingMoviesView = new UpcomingMoviesView(this);

    tabs.addTab(tabs.newTabSpec("movies_tab").setIndicator("Movies").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return allMoviesView;
          }
        }));

    tabs.addTab(tabs.newTabSpec("theaters_tab").setIndicator("Theaters").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return allTheatersView;
          }
        }));

    tabs.addTab(tabs.newTabSpec("upcoming_tab").setIndicator("Upcoming").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return upcomingMoviesView;
          }
        }));

    tabs.setOnTabChangedListener(
        new TabHost.OnTabChangeListener() {
          public void onTabChanged(String s) {
            int currentTab = getTabHost().getCurrentTab();
            controller.setSelectedTabIndex(currentTab);
          }
        });
  }


  @Override
  protected void onDestroy() {
    unbindService(serviceConnection);
    super.onDestroy();
  }


  @Override
	protected void onResume() {
    super.onResume();
    registerReceiver(broadcastReceiver, new IntentFilter(NowPlayingModel.NOW_PLAYING_MODEL_CHANGED_INTENT));
  }


  @Override
	protected void onPause() {
    unregisterReceiver(broadcastReceiver);
    super.onPause();
  }


  private void refresh() {
  }
}