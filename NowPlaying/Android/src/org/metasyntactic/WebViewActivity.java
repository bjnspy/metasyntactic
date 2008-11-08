package org.metasyntactic;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

public class WebViewActivity extends Activity {
  /** TODO: Set the path variable to a streaming video URL or a local media file path. */
  private String path;
  private WebView mWebView;


  @Override
  public void onCreate(Bundle icicle) {
    super.onCreate(icicle);
    mWebView = new WebView(this);
    setContentView(mWebView);
    path = getIntent().getExtras().getString("url");
    mWebView.loadUrl(path);
  }
}
