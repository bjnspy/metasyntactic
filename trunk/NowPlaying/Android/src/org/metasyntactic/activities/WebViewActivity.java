package org.metasyntactic.activities;

import android.os.Bundle;
import android.webkit.WebView;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class WebViewActivity extends AbstractNowPlayingActivity {
  @Override
  protected void onCreate(final Bundle bundle) {
    super.onCreate(bundle);
    setContentView(R.layout.license);
    
    final WebView webView = (WebView)findViewById(R.id.license);
    if ("license".equals(getIntent().getExtras().getString("type"))) {
      webView.loadUrl("file:///android_asset/License.html");
    } else {
      webView.loadUrl("file:///android_asset/credits.html");
    }
  }
}