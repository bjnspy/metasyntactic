package org.metasyntactic.activities;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebView;

public class LicenseActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.license);
    WebView license = (WebView) findViewById(R.id.license);
    license.loadUrl("file:///android_asset/License.html");
  }
}