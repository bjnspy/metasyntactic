package org.metasyntactic.activities;

import java.util.Map;

import org.metasyntactic.RefreshableContext;
import org.metasyntactic.services.NowPlayingServiceWrapper;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

public abstract class AbstractNowPlayingActivity extends Activity implements RefreshableContext {
  private final ActivityCore<AbstractNowPlayingActivity> core = new ActivityCore<AbstractNowPlayingActivity>(this);

  protected AbstractNowPlayingActivity() {
  }

  @Override protected void onCreate(final Bundle bundle) {
    super.onCreate(bundle);
    core.onCreate();
  }

  @Override protected void onResume() {
    super.onResume();
    core.onResume();
  }

  @Override protected void onPause() {
    core.onPause();
    super.onPause();
  }

  @Override protected void onDestroy() {
    core.onDestroy();
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    return core.onRetainNonConfigurationInstance();
  }

  @SuppressWarnings({"unchecked"}) @Override public Map<String, Object> getLastNonConfigurationInstance() {
    return (Map<String, Object>)super.getLastNonConfigurationInstance();
  }

  public Context getContext() {
    return core.getContext();
  }

  public NowPlayingServiceWrapper getService() {
    return core.getService();
  }

  public void onCreateAfterServiceConnected() {
  }

  public void onResumeAfterServiceConnected() {
  }

  public void refresh() {
  }
}
