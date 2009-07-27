package org.metasyntactic.activities;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout;
import org.metasyntactic.data.Movie;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.CustomGridView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Map;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class UpcomingMoviesActivity extends MoviesActivity {
  @Override public void onCreateAfterServiceConnected() {
    // check for sdcard mounted properly
    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
      getUserLocation();
      refresh();

      populateSections();
      postersAdapter = new UpcomingPostersAdapter();
      isGridSetup = true;
      grid.setAdapter(postersAdapter);
    } else {
      new AlertDialog.Builder(this).setTitle(R.string.insert_sdcard).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
        public void onClick(final DialogInterface dialog, final int whichButton) {
          finish();
        }
      }).show();
    }
  }

  @Override
  public void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);

    setContentView(R.layout.moviegrid_anim);
    bottomBar = (RelativeLayout)findViewById(R.id.bottom_bar);
    if (search == null) {
      bottomBar.setVisibility(View.GONE);
    }
    final View UpcomingMovies = findViewById(R.id.all_movies);
    UpcomingMovies.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(UpcomingMoviesActivity.this, UpcomingMoviesActivity.class);
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
    intent = new Intent();
    intent.setClass(this, UpcomingMovieDetailsActivity.class);
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    LogUtilities.i(getClass().getSimpleName(), "onNewIntent");
    super.onNewIntent(intent);
    refresh();
  }

  /**
   * Updates display of the list of movies.
   */
  @Override public void refresh() {
    if (search == null) {
      movies = new ArrayList<Movie>(getService().getUpcomingMovies());
    }
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(getService().getUpcomingMoviesSelectedSortIndex());
    Collections.sort(movies, comparator);
    super.refresh();
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
    clearBitmaps();
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    return super.onRetainNonConfigurationInstance();
  }

  protected class UpcomingPostersAdapter extends PostersAdapter {
    @Override
    public Object[] getSections() {
      // fast scroll is implemented only for alphabetic & score sort for release
      // 1.
      if (getService().getUpcomingMoviesSelectedSortIndex() == 0) {
        return actualSections.toArray();
      }
      if (getService().getUpcomingMoviesSelectedSortIndex() == 2) {
        return actualSections.toArray();
      }
      return null;
    }
  }

  @Override protected void populateSections() {
    super.populateSections();
    if (getService().getUpcomingMoviesSelectedSortIndex() == 0) {
      populateAlphaMovieSectionsAndPositions();
    } else if (getService().getUpcomingMoviesSelectedSortIndex() == 2) {
      populateScoreMovieSectionsAndPositions();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home)
    .setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SEARCH, 0, R.string.search).setIcon(android.R.drawable.ic_menu_search);
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_movies).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences)
    .setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes")).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this)
      .setKey(NowPlayingPreferenceDialog.PreferenceKeys.UPCOMING_MOVIES_SORT).setEntries(R.array.entries_movies_sort_preference)
      .setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      builder.setTitle(R.string.sort_movies);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEARCH) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SearchMovieActivity.class);
      localIntent.putExtra("activity", "UpcomingMoviesActivity");
      startActivity(localIntent);
      return true;
    }
    return false;
  }
}
