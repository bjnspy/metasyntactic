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

  private final DataProvider dataProvider = new DataProvider(this);
  private final ScoreCache scoreCache = new ScoreCache(this);
  private final UserLocationCache userLocationCache = new UserLocationCache();
  private final TrailerCache trailerCache = new TrailerCache();
  private final UpcomingCache upcomingCache = new UpcomingCache();
  private final PosterCache posterCache = new PosterCache(this);

  public NowPlayingModel(final Context applicationContext) {
    this.preferences = applicationContext.getSharedPreferences(NowPlayingModel.class.getName(), 0);
    loadData();

    initializeTestValues();
  }

  private void loadData() {
    final String lastVersion = this.preferences.getString(VERSION_KEY, "");
    if (!lastVersion.equals(version)) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.clear();
      editor.putString(VERSION_KEY, version);
      editor.commit();

      Application.reset();
      this.scoreCache.createDirectories();
    }
  }

  public void startup() {
    update();
  }

  public void shutdown() {
    this.dataProvider.shutdown();
    this.upcomingCache.shutdown();
    this.trailerCache.shutdown();
    this.posterCache.shutdown();
    this.scoreCache.shutdown();
  }

  public void update() {
    this.dataProvider.update();
    this.upcomingCache.update();
    updateTrailerCache();
    updatePosterCache();
    this.scoreCache.update();
  }

  private void initializeTestValues() {
    if (true) {
      //return;
    }

    setUserLocation("10009");
  }

  public UserLocationCache getUserLocationCache() {
    return this.userLocationCache;
  }

  private void updateTrailerCache() {
    this.trailerCache.update(getMovies());
  }

  private void updatePosterCache() {
    this.posterCache.update(getMovies());
  }

  private void updateIMDbCache() {
  }

  public String getUserLocation() {
    synchronized (this.preferencesLock) {
      return this.preferences.getString(USER_LOCATION_KEY, "");
    }
  }

  public void setUserLocation(final String userLocation) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putString(USER_LOCATION_KEY, userLocation);
      editor.commit();
    }
  }

  public int getSearchDistance() {
    synchronized (this.preferencesLock) {
      return this.preferences.getInt(SEARCH_DISTANCE_KEY, 5);
    }
  }

  public void setSearchDistance(int searchDistance) {
    synchronized (this.preferencesLock) {
      searchDistance = Math.min(Math.max(searchDistance, 1), 50);

      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putInt(SEARCH_DISTANCE_KEY, searchDistance);
      editor.commit();
    }
  }

  public Date getSearchDate() {
    synchronized (this.preferencesLock) {
      final String value = this.preferences.getString(SEARCH_DATE_KEY, "");
      if ("".equals(value)) {
        return DateUtilities.getToday();
      }

      final SimpleDateFormat format = new SimpleDateFormat();
      Date result = null;
      try {
        result = format.parse(value);
      } catch (final ParseException e) {
        throw new RuntimeException(e);
      }
      if (result.before(new Date())) {
        result = DateUtilities.getToday();
        setSearchDate(result);
      }

      return result;
    }
  }

  public void setSearchDate(final Date searchDate) {
    synchronized (this.preferencesLock) {
      final SimpleDateFormat format = new SimpleDateFormat();
      final String result = format.format(searchDate);

      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putString(SEARCH_DATE_KEY, result);
      editor.commit();
    }
  }

  public int getSelectedTabIndex() {
    synchronized (this.preferencesLock) {
      return this.preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
    }
  }

  public void setSelectedTabIndex(final int index) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putInt(SELECTED_TAB_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }

  public int getAllMoviesSelecetedSortIndex() {
    synchronized (this.preferencesLock) {
      return this.preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }

  public void setAllMoviesSelectedSortIndex(final int index) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }

  public int getAllTheatersSelectedSortIndex() {
    synchronized (this.preferencesLock) {
      return this.preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 0);
    }
  }

  public void setAllTheatersSelectedSortIndex(final int index) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    synchronized (this.preferencesLock) {
      return this.preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }

    Application.refresh();
  }

  public ScoreType getScoreType() {
    synchronized (this.preferencesLock) {
      final String value = this.preferences.getString(SCORE_TYPE_KEY, null);
      if (value == null) {
        return ScoreType.RottenTomatoes;
      }

      return ScoreType.valueOf(value);
    }
  }

  public void setScoreType(final ScoreType scoreType) {
    synchronized (this.preferencesLock) {
      final SharedPreferences.Editor editor = this.preferences.edit();
      editor.putString(SCORE_TYPE_KEY, scoreType.toString());
      editor.commit();
    }
  }

  public List<Movie> getMovies() {
    return this.dataProvider.getMovies();
  }

  public List<Theater> getTheaters() {
    return this.dataProvider.getTheaters();
  }

  public List<FavoriteTheater> getFavoriteTheaters() {
    return Collections.emptyList();
  }

  public void onDataProvidedUpdated() {
    updateIMDbCache();
    updatePosterCache();
    updateTrailerCache();
  }

  public List<String> getTrailers(final Movie movie) {
    return this.trailerCache.getTrailers(movie);
  }

  public Score getScore(final Movie movie) {
    return this.scoreCache.getScore(getMovies(), movie);
  }

  public List<Review> getReviews(final Movie movie) {
    return this.scoreCache.getReviews(getMovies(), movie);
  }

  private final static byte[] EMPTY_BYTES = new byte[0];

  public byte[] getPoster(final Movie movie) {
    byte[] bytes = this.posterCache.getPoster(movie);
    if (bytes != null) {
      return bytes;
    }

    bytes = this.upcomingCache.getPoster(movie);
    if (bytes != null) {
      return bytes;
    }

    return EMPTY_BYTES;
  }

  public String getSynopsis(final Movie movie) {
    final List<String> options = new ArrayList<String>();
    if (!isNullOrEmpty(movie.getSynopsis())) {
      options.add(movie.getSynopsis());
    }

    if (options.isEmpty() || Locale.getDefault().getLanguage().equals(Locale.ENGLISH.getLanguage())) {
      final Score score = getScore(movie);
      if (score != null && !isNullOrEmpty(score.getSynopsis())) {
        options.add(score.getSynopsis());
      }

      final String synopsis = this.upcomingCache.getSynopsis(movie);
      if (!isNullOrEmpty(synopsis)) {
        options.add(synopsis);
      }
    }

    String bestOption = "";
    for (final String s : options) {
      if (s.length() > bestOption.length()) {
        bestOption = s;
      }
    }
    return bestOption;
  }

  public String getImdbAddress(final Movie movie) {
    return movie.getImdbAddress();
  }

  public void prioritizeMovie(final Movie movie) {
    this.posterCache.prioritizeMovie(movie);
    this.scoreCache.prioritizeMovie(getMovies(), movie);
    this.trailerCache.prioritizeMovie(movie);
    this.upcomingCache.prioritizeMovie(movie);
  }

  public List<Theater> getTheatersShowingMovie(final Movie movie) {
    final List<Theater> result = new ArrayList<Theater>();
    for (final Theater theater : getTheaters()) {
      if (theater.getMovieTitles().contains(movie.getCanonicalTitle())) {
        result.add(theater);
      }
    }
    return result;
  }

  public List<Movie> getMoviesAtTheater(final Theater theater) {
    final List<Movie> result = new ArrayList<Movie>();
    for (final Movie movie : getMovies()) {
      if (theater.getMovieTitles().contains(movie.getCanonicalTitle())) {
        result.add(movie);
      }
    }
    return result;
  }

  public List<Performance> getPerformancesForMovieAtTheater(final Movie movie, final Theater theater) {
    return this.dataProvider.getPerformancesForMovieInTheater(movie, theater);
  }
}
