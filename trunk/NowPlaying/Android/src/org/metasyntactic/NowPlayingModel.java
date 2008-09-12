package org.metasyntactic;

import android.content.Context;
import android.content.Intent;
import org.metasyntactic.caches.AddressLocationCache;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.providers.DataProvider;

import java.util.List;
import java.util.prefs.Preferences;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingModel {
  public final static String NOW_PLAYING_MODEL_CHANGED_INTENT = "NowPlayingModelChangedIntent";

  private final static String USER_LOCATION = "userLocation";
  private final static String SELECTED_TAB_INDEX_KEY = "selectedTabIndex";
  private final static String ALL_MOVIES_SELECTED_SORT_INDEX_KEY = "allMoviesSelectedSortIndex";
  private final static String ALL_THEATERS_SELECTED_SORT_INDEX_KEY = "allTheatersSelectedSortIndex";
  private final static String UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY = "upcomingMoviesSelectedSortIndex";


  private final Context context;
  private final Preferences preferences = Preferences.userNodeForPackage(NowPlayingModel.class);


  private final DataProvider dataProvider = new DataProvider(this);
  private final AddressLocationCache addressLocationCache = new AddressLocationCache();


  public NowPlayingModel(Context context) {
    this.context = context;
  }


  public Context getContext() {
    return context;
  }


  public void broadcastChange() {
    context.sendBroadcast(new Intent(NOW_PLAYING_MODEL_CHANGED_INTENT));
  }


  public void update() {
    dataProvider.update();
    addressLocationCache.update();
  }


  public String getUserLocation() {
    return preferences.get(USER_LOCATION, "");
  }


  public void setUserLocation(String userLocation) {
    preferences.put(USER_LOCATION, userLocation);
  }


  public int getSelectedTabIndex() {
    return preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
  }


  public void setSelectedTabIndex(int index) {
    preferences.putInt(SELECTED_TAB_INDEX_KEY, index);
    broadcastChange();
  }


  public int getAllMoviesSelecetedSortIndex() {
    return preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setAllMoviesSelectedSortIndex(int index) {
    preferences.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
    broadcastChange();
  }


  public int getAllTheatersSelectedSortIndex() {
    return preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setAllTheatersSelectedSortIndex(int index) {
    preferences.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
    broadcastChange();
  }


  public int getUpcomingMovieSelectedSortIndex() {
    return preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setUpcomingMovieSelectedSortIndex(int index) {
    preferences.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
    broadcastChange();
  }


  public List<Movie> getMovies() {
    return dataProvider.getMovies();
  }


  public List<Theater> getTheaters() {
    return dataProvider.getTheaters();
  }
}
