package org.metasyntactic.activities;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.utilities.LogUtilities;

public class LicenseActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.license);
    NowPlayingControllerWrapper.addActivity(this);
    WebView license = (WebView) findViewById(R.id.license);
    license.loadUrl("file:///android_asset/License.html");
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  public Object onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }
}