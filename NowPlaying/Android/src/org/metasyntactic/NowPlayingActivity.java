package org.metasyntactic;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TabHost;
import org.metasyntactic.views.AllMoviesView;

public class NowPlayingActivity extends Activity {
  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.tabs);

    final TabHost tabs = (TabHost) findViewById(R.id.tab_host);
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