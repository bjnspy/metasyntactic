package org.metasyntactic.activities;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.util.Map;

/**
 * This activity shows a text field to ask the user to enter search terms and
 * then start the ThreadActivity with the correct postData to invoke a search.
 */

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class SearchMovieActivity extends AbstractNowPlayingActivity implements View.OnClickListener {
  private EditText mSearchText;
  private static String activityName;

  @Override protected void onResumeAfterServiceConnected() {
  }

  @Override protected void onCreateAfterServiceConnected() {
  }

  @Override
  public void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);

    setContentView(R.layout.search_bar);
    mSearchText = (EditText)findViewById(R.id.search_src_text);
    mSearchText.setOnClickListener(this);
    findViewById(R.id.search_go_btn).setOnClickListener(this);
    activityName = getIntent().getStringExtra("activity");
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    super.onPause();
  }

  @Override
  protected void onResume() {
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    super.onResume();
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

  // View.OnClickListener
  public final void onClick(final View v) {
    if (mSearchText.length() != 0) {
      performSearch();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    super.onCreateOptionsMenu(menu);
    menu.add(0, 0, 0, R.string.search).setAlphabeticShortcut(SearchManager.MENU_KEY)
      .setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
        public boolean onMenuItemClick(final MenuItem item) {
          performSearch();
          return true;
        }
      });
    return true;
  }

  private void performSearch() {
    final String searchTerm = mSearchText.getText().toString();
    privatePerformSearch(this, searchTerm, null);
  }

  public static void performLabel(final Context activity, final CharSequence label) {
    privatePerformSearch(activity, null, label);
  }

  private static void privatePerformSearch(final Context activity, final String search, final CharSequence label) {
    if (!StringUtilities.isNullOrEmpty(search) || !StringUtilities.isNullOrEmpty(label)) {
      final Intent intent = new Intent();
      if ("NowPlayingActivity".equals(activityName)) {
        intent.setClass(activity, NowPlayingActivity.class);
      } else {
        intent.setClass(activity, UpcomingMoviesActivity.class);
      }
      intent.putExtra("movie", search);
      activity.startActivity(intent);
    }
  }

  public void refresh() {
  }
}
