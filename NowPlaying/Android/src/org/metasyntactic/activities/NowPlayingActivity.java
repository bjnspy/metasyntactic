package org.metasyntactic.activities;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import static org.apache.commons.collections.CollectionUtils.isEmpty;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.data.Movie;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.views.CustomGridView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Map;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class NowPlayingActivity extends MoviesActivity {
  private static final String SEARCH_KEY = NowPlayingActivity.class.getSimpleName() + ".search";

  private TextView progressUpdate;

  private BroadcastReceiver progressBroadcastReceiver;
  private BroadcastReceiver dataBroadcastReceiver;

  private void showNoInformationFoundDialog() {
    new AlertDialog.Builder(this).setMessage(R.string.no_information).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int whichButton) {
      }
    }).show();
  }

  private void setupView() {
    // we're currently in 'downloading' mode. We need to deal with a few
    // cases. First, we deal with the case where a user has returned to
    // this activity, and now there are movies available. In that case, we
    // just display them.
    refresh();
    if (isEmpty(movies)) {
      // Ok. so we have no movies. THat means one of two things. Either
      // we're trying to download the movies, or we tried and failed to
      // download them. In the former case just wait. We'll get a
      // notification when they're done. In the latter case, let the user
      // know.
      if (!isNullOrEmpty(getService().getUserAddress()) && getService().getDataProviderState() == DataProvider.State.Finished) {
        showNoInformationFoundDialog();
      }
    } else {
      setupMovieGrid();
    }
  }

  @Override public void onCreateAfterServiceConnected() {
    // check for sdcard mounted properly
    if (FileUtilities.isSDCardAccessible()) {
      getUserLocation();
      refresh();
    }
  }

  @Override public void onResumeAfterServiceConnected() {
    if (!FileUtilities.isSDCardAccessible()) {
      return;
    }
    scrolling = false;

    progressBroadcastReceiver = new BroadcastReceiver() {
      @Override public void onReceive(final Context context, final Intent intent) {
        progressUpdate.setText(intent.getStringExtra("message"));
      }
    };
    dataBroadcastReceiver = new BroadcastReceiver() {
      @Override public void onReceive(final Context context, final Intent intent) {
        // the data provider finished downloading. set up our view accordingly.
        setupView();
      }
    };

    registerReceiver(dataBroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOADED));
    registerReceiver(progressBroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS));
    if (isGridSetup) {
      grid.setVisibility(View.VISIBLE);
      postersAdapter.notifyDataSetChanged();
    } else {
      setupView();
    }
  }

  @Override
  protected void onResume() {
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    super.onResume();
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    if (FileUtilities.isSDCardAccessible()) {

      if (dataBroadcastReceiver != null) {
        unregisterReceiver(dataBroadcastReceiver);
      }

      if (progressBroadcastReceiver != null) {
        unregisterReceiver(progressBroadcastReceiver);
      }
    }
    super.onPause();
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    if (FileUtilities.isSDCardAccessible()) {
      clearBitmaps();
    }
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");

    final Map<String, Object> state = super.onRetainNonConfigurationInstance();
    state.put(SEARCH_KEY, search);
    return state;
  }

  /**
   * Updates display of the list of movies.
   */
  @Override public void refresh() {
    if (search == null) {
      movies = new ArrayList<Movie>(getService().getMovies());
    }
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(getService().getAllMoviesSelectedSortIndex());
    Collections.sort(movies, comparator);
    super.refresh();
  }

  @Override
  public void onCreate(final Bundle bundle) {
    super.onCreate(bundle);
    LogUtilities.i(getClass().getSimpleName(), "onCreate");

    if (FileUtilities.isSDCardAccessible()) {
      // Request the progress bar to be shown in the title
      requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
      setContentView(R.layout.progressbar_1);
      progressUpdate = (TextView)findViewById(R.id.progress_update);
    } else {
      new AlertDialog.Builder(this).setTitle(R.string.insert_sdcard).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
        public void onClick(final DialogInterface dialog, final int whichButton) {
          finish();
        }
      }).show();
    }

    final Map<String, Object> state = getLastNonConfigurationInstance();
    if (state != null) {
      search = (String)state.get(SEARCH_KEY);
    }
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    LogUtilities.i(getClass().getSimpleName(), "onNewIntent");
    super.onNewIntent(intent);
    refresh();
  }

  private void setupMovieGrid() {
    if (isGridSetup) {
      return;
    }
    isGridSetup = true;
    setContentView(R.layout.moviegrid_anim);
    bottomBar = (RelativeLayout)findViewById(R.id.bottom_bar);
    if (search == null) {
      bottomBar.setVisibility(View.GONE);
    }
    final View allMovies = findViewById(R.id.all_movies);
    allMovies.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent().setClass(NowPlayingActivity.this, NowPlayingActivity.class);
        startActivity(intent);
        bottomBar.setVisibility(View.GONE);
      }
    });
    grid = (CustomGridView)findViewById(R.id.grid);
    grid.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(final AdapterView<?> parent, final View view, final int position, final long id) {
        selectedMovie = movies.get(position);
        setupRotationAnimation(view);
      }
    });
    populateSections();
    postersAdapter = new NowPlayingPostersAdapter();
    grid.setAdapter(postersAdapter);
    intent = new Intent().setClass(this, MovieDetailsActivity.class);
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_SEARCH, 0, R.string.search).setIcon(android.R.drawable.ic_menu_search);
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_movies).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.theaters).setIcon(R.drawable.ic_menu_allfriends);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.upcoming).setIcon(R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SEND_FEEDBACK, 0, R.string.send_feedback).setIcon(android.R.drawable.ic_menu_send);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences)
    .setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes")).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setKey(NowPlayingPreferenceDialog.PreferenceKeys.MOVIES_SORT)
      .setEntries(R.array.entries_movies_sort_preference).setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      builder.setTitle(R.string.sort_movies);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, AllTheatersActivity.class);
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_UPCOMING) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, UpcomingMoviesActivity.class);
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEARCH) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SearchMovieActivity.class);
      localIntent.putExtra("activity", "NowPlayingActivity");
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEND_FEEDBACK) {
      final Resources res = getResources();
      final String address = "cyrus.najmabadi@gmail.com, mjoshi@google.com";
      final Intent localIntent = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + address));
      localIntent.putExtra("subject", res.getString(R.string.feedback));
      final String body = getUserSettings();
      localIntent.putExtra("body", body);
      startActivity(localIntent);
      return true;
    }
    return false;
  }

  private String getUserSettings() {
    String body = "\n\n\n\n";
    body += NowPlayingApplication.getNameAndVersion(getResources());
    body += "\nAuto-Update Location: " + getService().isAutoUpdateEnabled();
    body += "\nLocation: " + getService().getUserAddress();
    body += "\nSearch Distance: " + getService().getSearchDistance();
    body += "\nReviews: " + getService().getScoreType();
    return body;
  }

  @Override protected void populateSections() {
    super.populateSections();
    if (getService().getAllMoviesSelectedSortIndex() == 0) {
      populateAlphaMovieSectionsAndPositions();
    } else if (getService().getAllMoviesSelectedSortIndex() == 2) {
      populateScoreMovieSectionsAndPositions();
    }
  }

  protected class NowPlayingPostersAdapter extends PostersAdapter {
    @Override
    public Object[] getSections() {
      // fast scroll is implemented only for alphabetic & score sort for release
      // 1.
      if (getService().getAllMoviesSelectedSortIndex() == 0) {
        return actualSections.toArray();
      }
      if (getService().getAllMoviesSelectedSortIndex() == 2) {
        return actualSections.toArray();
      }
      return null;
    }
  }
}
