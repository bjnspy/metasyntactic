package org.metasyntactic;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;
import java.util.prefs.Preferences;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingModel {
  private final static String SELECTED_TAB_INDEX_KEY = "selectedTabIndex";
  private final static String ALL_MOVIES_SELECTED_SORT_INDEX_KEY = "allMoviesSelectedSortIndex";
  private final static String ALL_THEATERS_SELECTED_SORT_INDEX_KEY = "allTheatersSelectedSortIndex";
  private final static String UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY = "upcomingMoviesSelectedSortIndex";

  private final Preferences preferences = Preferences.userNodeForPackage(NowPlayingModel.class);

  public void update() {
    new Thread(new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    });
  }

  private void updateBackgroundEntryPoint() {

  }

  public int getSelectedTabIndex() {
    return preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
  }

  public void setSelectedTabIndex(int index) {
    preferences.putInt(SELECTED_TAB_INDEX_KEY, index);
  }

  public int getAllMoviesSelecetedSortIndex() {
    return preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }

  public void setAllMoviesSelectedSortIndex(int index) {
    preferences.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
  }

  public int getAllTheatersSelectedSortIndex() {
    return preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 0);
  }

  public void setAllTheatersSelectedSortIndex(int index) {
    preferences.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
  }

  public int getUpcomingMovieSelectedSortIndex() {
    return preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }

  public void setUpcomingMovieSelectedSortIndex(int index) {
    preferences.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
  }

  public List<Movie> getMovies() {
    return null;
  }

  public List<Theater> getTheaters() {
    return null;
  }
}
