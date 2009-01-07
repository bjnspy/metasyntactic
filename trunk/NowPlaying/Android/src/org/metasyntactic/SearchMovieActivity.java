package org.metasyntactic;

import org.metasyntactic.utilities.StringUtilities;

import android.app.Activity;
import android.app.SearchManager;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

/**
 * This activity shows a text field to ask the user to enter search terms and
 * then start the ThreadActivity with the correct postData to invoke a search.
 */
/** @author mjoshi@google.com (Megha Joshi) */
public class SearchMovieActivity extends Activity implements View.OnClickListener {
  private EditText mSearchText;

  @Override
  public void onCreate(Bundle icicle) {
    super.onCreate(icicle);
    setContentView(R.layout.search_activity);
    mSearchText = (EditText) findViewById(R.id.search_term);
    mSearchText.setOnClickListener(this);
    findViewById(R.id.search_button).setOnClickListener(this);
  }

  // View.OnClickListener
  public final void onClick(View v) {
    if (mSearchText.length() != 0) {
      performSearch();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    super.onCreateOptionsMenu(menu);
    menu.add(0, 0, 0, R.string.search).setAlphabeticShortcut(SearchManager.MENU_KEY)
        .setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
          public boolean onMenuItemClick(MenuItem item) {
            performSearch();
            return true;
          }
        });
    return true;
  }

  private void performSearch() {
    String searchTerm = mSearchText.getText().toString();
    privatePerformSearch(this, getText(R.string.search) + " : " + searchTerm, searchTerm, null);
  }

  static public void performLabel(Activity activity, String label, String title) {
    privatePerformSearch(activity, title, null, label);
  }

  private static void privatePerformSearch(Activity activity, String title, String search,
      String label) {
    if (!StringUtilities.isNullOrEmpty(search) || !StringUtilities.isNullOrEmpty(label)) {
      Intent intent = new Intent();
      intent.setClass(activity, NowPlayingActivity.class);
      intent.putExtra("movie", search);
      activity.startActivity(intent);
    }
  }
}
