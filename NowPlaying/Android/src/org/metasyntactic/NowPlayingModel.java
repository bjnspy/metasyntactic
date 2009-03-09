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

import static org.metasyntactic.utilities.CollectionUtilities.size;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.metasyntactic.activities.R;
import org.metasyntactic.caches.IMDbCache;
import org.metasyntactic.caches.TrailerCache;
import org.metasyntactic.caches.UpcomingCache;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.caches.dvd.BlurayCache;
import org.metasyntactic.caches.dvd.DVDCache;
import org.metasyntactic.caches.posters.LargePosterCache;
import org.metasyntactic.caches.posters.PosterCache;
import org.metasyntactic.caches.scores.ScoreCache;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.io.Persistable;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.DateUtilities;
import org.metasyntactic.utilities.FileUtilities;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;

public class NowPlayingModel {
  private static final String PERSISTANCE_VERSION = "19";

  // These keys *MUST* end with "KEY"
  private static final String VERSION_KEY = "VERSION";
  private static final String USER_ADDRESS_KEY = "userAddress";
  private static final String SEARCH_DATE_KEY = "searchDate";
  private static final String SEARCH_DISTANCE_KEY = "searchDistance";
  private static final String SELECTED_TAB_INDEX_KEY = "selectedTabIndex";
  private static final String ALL_MOVIES_SELECTED_SORT_INDEX_KEY = "allMoviesSelectedSortIndex";
  private static final String ALL_THEATERS_SELECTED_SORT_INDEX_KEY = "allTheatersSelectedSortIndex";
  private static final String UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY = "upcomingMoviesSelectedSortIndex";
  private static final String SCORE_TYPE_KEY = "scoreType";
  private static final String AUTO_UPDATED_ENABLED_KEY = "autoUpdateEnabled";
  private static final String CLEAR_CACHE_KEY = "clearCache";

  private static final String[] STRING_KEYS_TO_MIGRATE = {USER_ADDRESS_KEY, SCORE_TYPE_KEY};

  private static final String[] INTEGER_KEYS_TO_MIGRATE = {SEARCH_DISTANCE_KEY};

  private static final String[] BOOLEAN_KEYS_TO_MIGRATE = {AUTO_UPDATED_ENABLED_KEY};

  // SharedPreferences is not thread-safe. so we need to lock when using it
  private final Object preferencesLock = new Object();
  private final SharedPreferences preferences;

  private final DataProvider dataProvider;
  private final ScoreCache scoreCache;
  private final UserLocationCache userLocationCache;
  private final TrailerCache trailerCache;
  private final UpcomingCache upcomingCache;
  private final PosterCache posterCache;
  private final LargePosterCache largePosterCache;
  private final IMDbCache imdbCache;
  private final DVDCache dvdCache;
  private final BlurayCache blurayCache;

  private Map<String, FavoriteTheater> favoriteTheaters;

  public NowPlayingModel(final Context applicationContext) {
    preferences = applicationContext.getSharedPreferences(NowPlayingModel.class.getName(), 0);
    loadData();
    clearCaches();

    dataProvider = new DataProvider(this);
    scoreCache = new ScoreCache(this);
    userLocationCache = new UserLocationCache();
    trailerCache = new TrailerCache(this);
    upcomingCache = new UpcomingCache(this);
    posterCache = new PosterCache(this);
    largePosterCache = new LargePosterCache(this);
    imdbCache = new IMDbCache(this);
    dvdCache = new DVDCache(this);
    blurayCache = new BlurayCache(this);
  }

  private void clearCaches() {
    final int version;
    synchronized (preferencesLock) {
      version = preferences.getInt(CLEAR_CACHE_KEY, 1);
      preferences.edit().putInt(CLEAR_CACHE_KEY, version + 1).commit();
    }

    if (version % 10 == 0) {
      largePosterCache.clearStaleData();
      upcomingCache.clearStaleData();
      trailerCache.clearStaleData();
      posterCache.clearStaleData();
      scoreCache.clearStaleData();
      imdbCache.clearStaleData();
      dvdCache.clearStaleData();
      blurayCache.clearStaleData();
    }
  }

  private void loadData() {
    final String lastVersion = preferences.getString(VERSION_KEY, "");
    if (!lastVersion.equals(PERSISTANCE_VERSION)) {
      final Map<String, Object> currentPreferences = getPreferencesToMigrate();

      final SharedPreferences.Editor editor = preferences.edit();
      editor.clear();
      editor.putString(VERSION_KEY, PERSISTANCE_VERSION);
      editor.commit();

      restorePreferences(currentPreferences);

      NowPlayingApplication.reset();
    }
  }

  private void restorePreferences(final Map<String, Object> currentPreferences) {
    final SharedPreferences.Editor editor = preferences.edit();

    for (final String key : STRING_KEYS_TO_MIGRATE) {
      final Object value = currentPreferences.get(key);
      if (value != null && value instanceof String) {
        editor.putString(key, (String)value);
      }
    }

    for (final String key : INTEGER_KEYS_TO_MIGRATE) {
      final Object value = currentPreferences.get(key);
      if (value != null && value instanceof Integer) {
        editor.putInt(key, (Integer)value);
      }
    }

    for (final String key : BOOLEAN_KEYS_TO_MIGRATE) {
      final Object value = currentPreferences.get(key);
      if (value != null && value instanceof Boolean) {
        editor.putBoolean(key, (Boolean)value);
      }
    }

    editor.commit();
  }

  private Map<String, Object> getPreferencesToMigrate() {
    final Map<String, Object> map = new HashMap<String, Object>();
    for (final String key : STRING_KEYS_TO_MIGRATE) {
      final String value = preferences.getString(key, null);
      if (value != null) {
        map.put(key, value);
      }
    }

    for (final String key : INTEGER_KEYS_TO_MIGRATE) {
      final int value = preferences.getInt(key, -1);
      if (value != -1) {
        map.put(key, value);
      }
    }

    for (final String key : BOOLEAN_KEYS_TO_MIGRATE) {
      final boolean value = preferences.getBoolean(key, false);
      map.put(key, value);
    }

    return map;
  }

  public void onLowMemory() {
    dataProvider.onLowMemory();
    largePosterCache.onLowMemory();
    upcomingCache.onLowMemory();
    trailerCache.onLowMemory();
    posterCache.onLowMemory();
    scoreCache.onLowMemory();
    imdbCache.onLowMemory();
    dvdCache.onLowMemory();
    blurayCache.onLowMemory();
  }

  public void shutdown() {
    dataProvider.shutdown();
    largePosterCache.shutdown();
    upcomingCache.shutdown();
    trailerCache.shutdown();
    posterCache.shutdown();
    scoreCache.shutdown();
    imdbCache.shutdown();
    dvdCache.shutdown();
    blurayCache.shutdown();
  }

  public void update() {
    updatePrimaryCaches();
  }

  private void updatePrimaryCaches() {
    dataProvider.update();
  }

  public void updateSecondaryCaches() {
    scoreCache.update();
    trailerCache.update(getMovies());
    posterCache.update(getMovies());
    upcomingCache.update();
    imdbCache.update(getMovies());
    dvdCache.update();
    blurayCache.update();
  }

  public UserLocationCache getUserLocationCache() {
    return userLocationCache;
  }

  public PosterCache getPosterCache() {
    return posterCache;
  }

  public String getUserAddress() {
    synchronized (preferencesLock) {
      return preferences.getString(USER_ADDRESS_KEY, "");
    }
  }

  public void setUserAddress(final String userLocation) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putString(USER_ADDRESS_KEY, userLocation);
      editor.commit();
    }
    markDataProviderOutOfDate();
  }

  public int getSearchDistance() {
    synchronized (preferencesLock) {
      return preferences.getInt(SEARCH_DISTANCE_KEY, 5);
    }
  }

  public void setSearchDistance(int searchDistance) {
    synchronized (preferencesLock) {
      searchDistance = Math.min(Math.max(searchDistance, 1), 50);
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(SEARCH_DISTANCE_KEY, searchDistance);
      editor.commit();
    }
  }

  public Date getSearchDate() {
    synchronized (preferencesLock) {
      final long value = preferences.getLong(SEARCH_DATE_KEY, 0);
      if (0 == value) {
        return DateUtilities.getToday();
      }
      Date result = new Date(value);
      if (result.before(new Date())) {
        result = DateUtilities.getToday();
        setSearchDate(result);
      }
      return result;
    }
  }

  public void setSearchDate(final Date searchDate) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putLong(SEARCH_DATE_KEY, searchDate.getTime());
      editor.commit();
    }
    markDataProviderOutOfDate();
  }

  private static void markDataProviderOutOfDate() {
    DataProvider.markOutOfDate();
  }

  public int getSelectedTabIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
    }
  }

  public void setSelectedTabIndex(final int index) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(SELECTED_TAB_INDEX_KEY, index);
      editor.commit();
    }
    NowPlayingApplication.refresh();
  }

  public int getAllMoviesSelecetedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }

  public void setAllMoviesSelectedSortIndex(final int index) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }
    NowPlayingApplication.refresh();
  }

  public int getAllTheatersSelectedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 1);
    }
  }

  public void setAllTheatersSelectedSortIndex(final int index) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }
    NowPlayingApplication.refresh();
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    synchronized (preferencesLock) {
      return preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
    }
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
      editor.commit();
    }
    NowPlayingApplication.refresh();
  }

  public ScoreType getScoreType() {
    synchronized (preferencesLock) {
      final String value = preferences.getString(SCORE_TYPE_KEY, null);
      if (value == null) {
        return ScoreType.Google;
      }
      return ScoreType.valueOf(value);
    }
  }

  public void setScoreType(final Object scoreType) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putString(SCORE_TYPE_KEY, scoreType.toString());
      editor.commit();
    }
  }

  public boolean isAutoUpdateEnabled() {
    synchronized (preferencesLock) {
      return preferences.getBoolean(AUTO_UPDATED_ENABLED_KEY, false);
    }
  }

  public void setAutoUpdateEnabled(final boolean enabled) {
    synchronized (preferencesLock) {
      final SharedPreferences.Editor editor = preferences.edit();
      editor.putBoolean(AUTO_UPDATED_ENABLED_KEY, enabled);
      editor.commit();
    }
  }

  public List<Movie> getMovies() {
    return dataProvider.getMovies();
  }

  public List<Theater> getTheaters() {
    return dataProvider.getTheaters();
  }

  private static File getFavoriteTheatersFile() {
    return new File(NowPlayingApplication.dataDirectory, "FavoriteTheaters");
  }

  private void saveFavoriteTheaters() {
    FileUtilities.writeStringToPersistableMap(favoriteTheaters, getFavoriteTheatersFile());
  }

  private void ensureFavoriteTheaters() {
    if (favoriteTheaters == null) {
      favoriteTheaters = FileUtilities.readStringToPersistableMap(FavoriteTheater.reader, getFavoriteTheatersFile());
      if (CollectionUtilities.isEmpty(favoriteTheaters)) {
        favoriteTheaters = new HashMap<String, FavoriteTheater>();
      }
    }
  }

  public Collection<FavoriteTheater> getFavoriteTheaters() {
    ensureFavoriteTheaters();
    return favoriteTheaters.values();
  }

  public void addFavoriteTheater(final Theater theater) {
    ensureFavoriteTheaters();
    final FavoriteTheater favorite = new FavoriteTheater(theater.getName(), theater.getOriginatingLocation());
    favoriteTheaters.put(favorite.getName(), favorite);
    saveFavoriteTheaters();
  }

  public void removeFavoriteTheater(final Theater theater) {
    ensureFavoriteTheaters();
    favoriteTheaters.remove(theater.getName());
    saveFavoriteTheaters();
  }

  public boolean isFavoriteTheater(final Theater theater) {
    ensureFavoriteTheaters();
    return favoriteTheaters.containsKey(theater.getName());
  }

  public static String getTrailer(final Movie movie) {
    final String trailer = TrailerCache.getTrailer(movie);
    if (!isNullOrEmpty(trailer)) {
      return trailer;
    }

    return UpcomingCache.getTrailer(movie);
  }

  public Score getScore(final Movie movie) {
    return scoreCache.getScore(getMovies(), movie);
  }

  public List<Review> getReviews(final Movie movie) {
    return scoreCache.getReviews(getMovies(), movie);
  }

  public static List<String> getCast(final Movie movie) {
    if (!movie.getCast().isEmpty()) {
      return movie.getCast();
    }

    return UpcomingCache.getCast(movie);
  }

  private static final byte[] EMPTY_BYTES = new byte[0];

  public static byte[] getPoster(final Movie movie) {
    byte[] bytes = PosterCache.getPoster(movie);
    if (size(bytes) > 0) {
      return bytes;
    }
    bytes = LargePosterCache.getPoster(movie);
    if (size(bytes) > 0) {
      return bytes;
    }
    return EMPTY_BYTES;
  }

  public static File getPosterFile_safeToCallFromBackground(final Movie movie) {
    File file = PosterCache.getPosterFile_safeToCallFromBackground(movie);
    if (file != null && file.exists()) {
      return file;
    }

    file = LargePosterCache.getPosterFile_safeToCallFromBackground(movie);
    if (file != null && file.exists()) {
      return file;
    }

    return null;
  }

  public String getSynopsis(final Movie movie) {
    final Collection<String> options = new ArrayList<String>();
    if (!isNullOrEmpty(movie.getSynopsis())) {
      options.add(movie.getSynopsis());
    }
    if (options.isEmpty() || Locale.getDefault().getLanguage().equals(Locale.ENGLISH.getLanguage())) {
      final Score score = getScore(movie);
      if (score != null && !isNullOrEmpty(score.getSynopsis())) {
        options.add(score.getSynopsis());
      }
      final String synopsis = UpcomingCache.getSynopsis(movie);
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

  public static String getIMDbAddress(final Movie movie) {
    String result = movie.getIMDbAddress();
    if (!isNullOrEmpty(result)) {
      return result;
    }

    result = IMDbCache.getIMDbAddress(movie);
    if (!isNullOrEmpty(result)) {
      return result;
    }

    result = UpcomingCache.getIMDbAddress(movie);
    if (!isNullOrEmpty(result)) {
      return result;
    }

    return "";
  }

  public void prioritizeMovie(final Movie movie) {
    if (movie == null) {
      return;
    }
    posterCache.prioritizeMovie(movie);
    scoreCache.prioritizeMovie(getMovies(), movie);
    trailerCache.prioritizeMovie(movie);
    upcomingCache.prioritizeMovie(movie);
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
    return dataProvider.getPerformancesForMovieInTheater(movie, theater);
  }

  public static void reportLocationForAddress(final Persistable location, final String address) {
    UserLocationCache.reportLocationForAddress(location, address);
  }

  public List<Movie> getUpcomingMovies() {
    return upcomingCache.getMovies();
  }

  public LargePosterCache getLargePosterCache() {
    return largePosterCache;
  }

  public DataProvider.State getDataProviderState() {
    return dataProvider.getState();
  }

  public boolean isStale(final Theater theater) {
    Boolean stale = theater.isStale();
    if (stale == null) {
      stale = dataProvider.isStale(theater);
      theater.setStale(stale);
    }

    return stale;
  }

  public String getShowtimesRetrievedOnString(final Theater theater, final Resources resources) {
    if (isStale(theater)) {
      final Date date = dataProvider.synchronizationDateForTheater(theater);
      if (date == null) {
        return "";
      }
      return resources.getString(R.string.theater_last_reported_show_times_on_string_dot, DateUtilities.formatLongDate(date));
    } else {
      return resources.getString(R.string.show_times_retrieved_on_string_dot, DateUtilities.formatLongDate(DateUtilities.getToday()));
    }
  }

  //public boolean

  //- (BOOL) isStale:(Theater*) theater;
  //- (NSString*) showtimesRetrievedOnString:(Theater*) theater;

  public IMDbCache getIMDbCache() {
    return imdbCache;
  }
}
