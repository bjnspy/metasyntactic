//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic;

import android.content.Context;
import android.content.SharedPreferences;
import org.metasyntactic.caches.TrailerCache;
import org.metasyntactic.caches.UpcomingCache;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.caches.posters.PosterCache;
import org.metasyntactic.caches.scores.ScoreCache;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.utilities.DateUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class NowPlayingModel {
  private final static String version = "3";
  private final static String VERSION_KEY = "version";
  private final static String USER_LOCATION_KEY = "userLocation";
  private final static String SEARCH_DATE_KEY = "searchDate";
  private final static String SEARCH_DISTANCE_KEY = "searchDistance";
  private final static String SELECTED_TAB_INDEX_KEY = "selectedTabIndex";
  private final static String ALL_MOVIES_SELECTED_SORT_INDEX_KEY = "allMoviesSelectedSortIndex";
  private final static String ALL_THEATERS_SELECTED_SORT_INDEX_KEY = "allTheatersSelectedSortIndex";
  private final static String UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY = "upcomingMoviesSelectedSortIndex";
  private final static String SCORE_TYPE_KEY = "scoreType";

  // SharedPreferences is not threadsafe.  so we need to lock when using it
  private final Object preferencesLock = new Object();
  private final SharedPreferences preferences;

  private final Context context;

  private final DataProvider dataProvider = new DataProvider(this);
  private final ScoreCache scoreCache = new ScoreCache(this);
  private final UserLocationCache userLocationCache = new UserLocationCache();
  private final TrailerCache trailerCache = new TrailerCache();
  private final UpcomingCache upcomingCache = new UpcomingCache();
  private final PosterCache posterCache = new PosterCache(this);


  public NowPlayingModel(Context context) {
    this.context = context;
    this.preferences = NowPlayingActivity.instance.getSharedPreferences(NowPlayingModel.class.getName(), 0);

    loadData();

    initializeTestValues();
  }


  private void loadData() {
    String lastVersion = preferences.getString(VERSION_KEY, "");
    if (!lastVersion.equals(version)) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.clear();
      editor.putString(VERSION_KEY, version);
      editor.commit();

      Application.reset();
      scoreCache.createDirectories();
    }
  }


  private void initializeTestValues() {
    if (true) {
      //return;
    }

    this.setUserLocation("10009");
  }


  public UserLocationCache getUserLocationCache() {
    return userLocationCache;
  }


  public Context getContext() {
    return context;
  }


  private void updateTrailerCache() {
    trailerCache.update(getMovies());
  }


  private void updatePosterCache() {
    posterCache.update(getMovies());
  }


  private void updateIMDbCache() {
  }


  public void update() {
    dataProvider.update();
    upcomingCache.update();
    updateTrailerCache();
    updatePosterCache();
    scoreCache.update();

  }


  public String getUserLocation() {
    synchronized (preferencesLock) {
      return preferences.getString(USER_LOCATION_KEY, "");
    }
  }


  public void setUserLocation(String userLocation) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putString(USER_LOCATION_KEY, userLocation);
      editor.commit();
    }
  }


  public int getSearchDistance() {
    synchronized (preferencesLock) {
      return preferences.getInt(SEARCH_DISTANCE_KEY, 5);
    }
  }


  public void setSearchDistance(int searchDistance) {
    synchronized (preferencesLock) {
      searchDistance = Math.min(Math.max(searchDistance, 1), 50);

      SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(SEARCH_DISTANCE_KEY, searchDistance);
      editor.commit();
    }
  }


  public Date getSearchDate() {
    synchronized (preferencesLock) {
      String value = preferences.getString(SEARCH_DATE_KEY, "");
      if ("".equals(value)) {
        return DateUtilities.getToday();
      }

      SimpleDateFormat format = new SimpleDateFormat();
      Date result = null;
      try {
        result = format.parse(value);
      } catch (ParseException e) {
        throw new RuntimeException(e);
      }
      if (result.before(new Date())) {
        result = DateUtilities.getToday();
        setSearchDate(result);
      }

      return result;
    }
  }


  public void setSearchDate(Date searchDate) {
    synchronized (preferencesLock) {
      SimpleDateFormat format = new SimpleDateFormat();
      String result = format.format(searchDate);

      SharedPreferences.Editor editor = preferences.edit();
      editor.putString(SEARCH_DATE_KEY, result);
      editor.commit();
    }
  }


  public int getSelectedTabIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
    }
  }


  public void setSelectedTabIndex(int index) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(SELECTED_TAB_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }


  public int getAllMoviesSelecetedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }


  public void setAllMoviesSelectedSortIndex(int index) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }


  public int getAllTheatersSelectedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 0);
    }
  }


  public void setAllTheatersSelectedSortIndex(int index) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }


  public int getUpcomingMoviesSelectedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }


  public void setUpcomingMoviesSelectedSortIndex(int index) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }


  public ScoreType getScoreType() {
    synchronized (preferencesLock) {
      String value = preferences.getString(SCORE_TYPE_KEY, null);
      if (value == null) {
        return ScoreType.RottenTomatoes;
      }

      return ScoreType.valueOf(value);
    }
  }


  public void setScoreType(ScoreType scoreType) {
    synchronized (preferencesLock) {
      SharedPreferences.Editor editor = preferences.edit();
      editor.putString(SCORE_TYPE_KEY, scoreType.toString());
      editor.commit();
    }
  }


  public List<Movie> getMovies() {
    return dataProvider.getMovies();
  }


  public List<Theater> getTheaters() {
    return dataProvider.getTheaters();
  }


  public List<FavoriteTheater> getFavoriteTheaters() {
    return Collections.emptyList();
  }


  public void onDataProvidedUpdated() {
    updateIMDbCache();
    updatePosterCache();
    updateTrailerCache();
  }


  public List<String> getTrailers(Movie movie) {
    return trailerCache.getTrailers(movie);
  }


  public Score getScore(Movie movie) {
    return scoreCache.getScore(getMovies(), movie);
  }


  public List<Review> getReviews(Movie movie) {
    return scoreCache.getReviews(getMovies(), movie);
  }


  public byte[] getPoster(Movie movie) {
    byte[] bytes = posterCache.getPoster(movie);
    if (bytes != null) {
      return bytes;
    }

    bytes = upcomingCache.getPoster(movie);
    if (bytes != null) {
      return bytes;
    }

    return null;
  }


  public String getSynopsis(Movie movie) {
    List<String> options = new ArrayList<String>();
    if (!isNullOrEmpty(movie.getSynopsis())) {
      options.add(movie.getSynopsis());
    }

    if (options.isEmpty() || Locale.getDefault().getLanguage().equals(Locale.ENGLISH.getLanguage())) {
      Score score = getScore(movie);
      if (score != null && !isNullOrEmpty(score.getSynopsis())) {
        options.add(score.getSynopsis());
      }

      String synopsis = upcomingCache.getSynopsis(movie);
      if (!isNullOrEmpty(synopsis)) {
        options.add(synopsis);
      }
    }

    String bestOption = "";
    for (String s : options) {
      if (s.length() > bestOption.length()) {
        bestOption = s;
      }
    }
    return bestOption;
  }


  public String getImdbAddress(Movie movie) {
    return movie.getImdbAddress();
  }

}
