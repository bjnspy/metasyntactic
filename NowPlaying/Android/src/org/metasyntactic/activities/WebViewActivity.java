package org.metasyntactic.activities;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.utilities.LogUtilities;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class WebViewActivity extends Activity {
  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.license);
    NowPlayingControllerWrapper.addActivity(this);
    final WebView webView = (WebView)findViewById(R.id.license);
    if (this.getIntent().getExtras().getString("type").equals("license"))
    webView.loadUrl("file:///android_asset/License.html");
    else
      webView.loadUrl("file:///android_asset/credits.html");
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