package org.metasyntactic;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.view.View;
import android.widget.Button;
import android.widget.TabHost;
import org.metasyntactic.views.AllMoviesView;

public class NowPlayingActivity extends Activity {
  private INowPlayingController controller;

  private final ServiceConnection serviceConnection =
      new ServiceConnection() {
        public void onServiceConnected(ComponentName className, IBinder service) {
          // This is called when the connection with the service has been
          // established, giving us the service object we can use to
          // interact with the service.  We are communicating with our
          // service through an IDL interface, so get a client-side
          // representation of that from the raw service object.
          controller = INowPlayingController.Stub.asInterface(service);
          try {
            controller.setUserLocation("10009");
          } catch (RemoteException e) {
            throw new RuntimeException(e);
          }
        }

        public void onServiceDisconnected(ComponentName className) {
          controller = null;
        }
      };


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

    final TabHost tabs = (TabHost) this.findViewById(R.id.tab_host);
    tabs.setup();

    final View[] views = new View[]{
        new AllMoviesView(this),
        new Button(this),
        new Button(this)
    };

    tabs.addTab(tabs.newTabSpec("movies_tab").setIndicator("Movies").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return views[0];
          }
        }));

    tabs.addTab(tabs.newTabSpec("theaters_tab").setIndicator("Theaters").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return views[1];
          }
        }));

    tabs.addTab(tabs.newTabSpec("upcoming_tab").setIndicator("Upcoming").setContent(
        new TabHost.TabContentFactory() {
          public View createTabContent(String s) {
            return views[2];
          }
        }));

    tabs.setOnTabChangedListener(
        new TabHost.OnTabChangeListener() {
          public void onTabChanged(String s) {
            views[tabs.getCurrentTab()].invalidate();
          }
        });

    tabs.setCurrentTab(0);
  }
}