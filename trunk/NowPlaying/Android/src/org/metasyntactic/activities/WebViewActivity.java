package org.metasyntactic.activities;

import android.os.Bundle;
import android.webkit.WebView;
import org.metasyntactic.utilities.LogUtilities;

import java.util.Map;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class WebViewActivity extends AbstractNowPlayingActivity {
  @Override protected void onResumeAfterServiceConnected() {
  }

  @Override protected void onCreateAfterServiceConnected() {
    final WebView webView = (WebView)findViewById(R.id.license);
    if ("license".equals(getIntent().getExtras().getString("type"))) {
      webView.loadUrl("file:///android_asset/License.html");
    } else {
      webView.loadUrl("file:///android_asset/credits.html");
    }
  }

  @Override
  protected void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);
    setContentView(R.layout.license);
  }

  @Override
  protected void onResume() {
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    super.onResume();
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    super.onPause();
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    return super.onRetainNonConfigurationInstance();
  }

  public void refresh() {
  }
}