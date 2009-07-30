package org.metasyntactic.activities;

import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.RefreshableContext;
import org.metasyntactic.services.NowPlayingService;
import org.metasyntactic.utilities.LogUtilities;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

public abstract class AbstractNowPlayingActivity extends Activity implements RefreshableContext {
  private final ActivityCore<AbstractNowPlayingActivity> core = new ActivityCore<AbstractNowPlayingActivity>(this);

  protected AbstractNowPlayingActivity() {
  }

  @Override protected void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);
    core.onCreate();
  }

  @Override protected void onResume() {
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    super.onResume();
    core.onResume();
  }

  @Override protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    core.onPause();
    super.onPause();
  }

  @Override protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    core.onDestroy();
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    return core.onRetainNonConfigurationInstance();
  }

  @SuppressWarnings({"unchecked"}) @Override public Map<String, Object> getLastNonConfigurationInstance() {
    return (Map<String, Object>)super.getLastNonConfigurationInstance();
  }

  public Context getContext() {
    return core.getContext();
  }

  public void refresh() {
  }
  
  protected NowPlayingService getService() {
    return NowPlayingApplication.getService();
  }
}
