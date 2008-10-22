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
import android.content.Intent;
import android.os.Handler;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.caches.TrailerCache;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.caches.scores.ScoreCache;
import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.DateUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.difference.EditDistance;

import java.io.File;
import java.util.*;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingModel {
	private final static String version = "1";
	private final static String VERSION_KEY = "version";
  private final static String USER_LOCATION_KEY = "userLocation";
  private final static String SEARCH_DATE_KEY = "searchDate";
  private final static String SEARCH_DISTANCE_KEY = "searchDistance";
  private final static String SELECTED_TAB_INDEX_KEY = "selectedTabIndex";
  private final static String ALL_MOVIES_SELECTED_SORT_INDEX_KEY = "allMoviesSelectedSortIndex";
  private final static String ALL_THEATERS_SELECTED_SORT_INDEX_KEY = "allTheatersSelectedSortIndex";
  private final static String UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY = "upcomingMoviesSelectedSortIndex";
  private final static String SCORE_TYPE_KEY = "scoreType";


  private final Context context;
  private final Preferences preferences = Preferences.userNodeForPackage(NowPlayingModel.class);

  private final Object movieMapLock = new Object();
  private Map<String,String> movieMap;

  private final DataProvider dataProvider = new DataProvider(this);
  private final ScoreCache scoreCache = new ScoreCache(this);
  private final UserLocationCache userLocationCache = new UserLocationCache();
  private final TrailerCache trailerCache = new TrailerCache();


  public NowPlayingModel(Context context) {
    this.context = context;
    
    this.loadData();
    movieMap = FileUtilities.readObject(movieMapFile());
    
    initializeTestValues();
  }
  
  
  private void loadData() {
  	String lastVersion = preferences.get(VERSION_KEY, "");
  	if (!lastVersion.equals(version)) {
  		try {
				preferences.clear();
			} catch (BackingStoreException e) {
				throw new RuntimeException(e);
			}
			
			Application.reset();
			
			preferences.put(VERSION_KEY, version);
  	}
  }


  private void initializeTestValues() {
  	if (true) {
  		//return;
  	}
  	
  	this.setUserLocation("10009");
	}


	private String movieMapFile() {
    return new File(Application.dataDirectory, "MovieMap").getAbsolutePath();
  }


  public UserLocationCache getUserLocationCache() {
    return userLocationCache;
  }


  public Context getContext() {
    return context;
  }


  public void update() {
    update(0);
  }


  private void update(final int i) {
    if (i == 0) {
      dataProvider.update();
    } else if (i == 1) {
      trailerCache.update(this.getMovies());
    } else {
      return;
    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
      public void run() { update(i + 1); }
    };
    handler.postDelayed(runnable, 1000);
  }


  public String getUserLocation() {
    return preferences.get(USER_LOCATION_KEY, "");
  }


  public void setUserLocation(String userLocation) {
    preferences.put(USER_LOCATION_KEY, userLocation);
  }


  public int getSearchDistance() {
    return preferences.getInt(SEARCH_DISTANCE_KEY, 5);
  }


  public void setSearchDistance(int searchDistance) {
  	searchDistance = Math.min(Math.max(searchDistance, 1), 50);
  	preferences.putInt(SEARCH_DISTANCE_KEY, searchDistance);
  }


  public Date getSearchDate() {
    String value = preferences.get(SEARCH_DATE_KEY, "");
    if ("".equals(value)) {
      return DateUtilities.getToday();
    }

    DateTimeFormatter formatter = ISODateTimeFormat.dateTime();
    Date result = formatter.parseDateTime(value).toDate();
    if (result.before(new Date())) {
      result = DateUtilities.getToday();
      setSearchDate(result);
    }

    return result;
  }


  public void setSearchDate(Date searchDate) {
    DateTimeFormatter formatter = ISODateTimeFormat.dateTime();
    String result = formatter.print(new DateTime(searchDate));
    preferences.put(SEARCH_DATE_KEY, result);
  }


  public int getSelectedTabIndex() {
    return preferences.getInt(SELECTED_TAB_INDEX_KEY, 0);
  }


  public void setSelectedTabIndex(int index) {
    preferences.putInt(SELECTED_TAB_INDEX_KEY, index);
    Application.refresh();
  }


  public int getAllMoviesSelecetedSortIndex() {
    return preferences.getInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setAllMoviesSelectedSortIndex(int index) {
    preferences.putInt(ALL_MOVIES_SELECTED_SORT_INDEX_KEY, index);
    Application.refresh();
  }


  public int getAllTheatersSelectedSortIndex() {
    return preferences.getInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setAllTheatersSelectedSortIndex(int index) {
    preferences.putInt(ALL_THEATERS_SELECTED_SORT_INDEX_KEY, index);
    Application.refresh();
  }


  public int getUpcomingMovieSelectedSortIndex() {
    return preferences.getInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, 0);
  }


  public void setUpcomingMovieSelectedSortIndex(int index) {
    preferences.putInt(UPCOMING_MOVIES_SELECTED_SORT_INDEX_KEY, index);
    Application.refresh();
  }


  public ScoreType getRatingsProvider() {
    String value = preferences.get(SCORE_TYPE_KEY, null);
    if (value == null) {
      return ScoreType.RottenTomatoes;
    }

    return ScoreType.valueOf(value);
  }

  public void setRatingsProvider(ScoreType providerType) {
    preferences.put(SCORE_TYPE_KEY, providerType.toString());
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
    regenerateMovieMap();
    updateIMDbCache();
    updatePosterCache();
    updateTrailerCache();
  }

  public void onRatingsUpdated() {
  }

  private void updateTrailerCache() {
    trailerCache.update(getMovies());
  }


  private void updatePosterCache() {
  }


  private void updateIMDbCache() {

  }


  private void regenerateMovieMap() {
    final List<Movie> movies = getMovies();
    final Map<String, Score> scores = getScores();

    Runnable runnable = new Runnable() {
      public void run() {
        createMovieMap(movies, scores);
      }
    };
    ThreadingUtilities.performOnBackgroundThread(runnable, movieMapLock, true/*visible*/);
  }


  private void createMovieMap(List<Movie> movies, Map<String, Score> scores) {
    final Map<String,String> result = new HashMap<String, String>();

    List<String> titles = new ArrayList<String>(scores.keySet());
    List<String> lowercaseTitles = new ArrayList<String>();
    for (String title : titles) {
    lowercaseTitles.add(title.toLowerCase());
  }

    for (Movie movie : movies) {
        String lowercaseTitle = movie.getCanonicalTitle().toLowerCase();
      int index = EditDistance.findClosestMatchIndex(lowercaseTitle, lowercaseTitles);

      if (index >= 0) {
            String title = titles.get(index);
        result.put(movie.getCanonicalTitle(), title);
        }
    }

    FileUtilities.writeObject(result, movieMapFile());

    Runnable runnable = new Runnable() {
      public void run() {
        reportMovemap(result);
      }
    };

    ThreadingUtilities.performOnMainThread(runnable);
  }


  private void reportMovemap(Map<String, String> result) {
    movieMap = result;
    Application.refresh(true);
  }


  private Map<String, Score> getScores() {
    return scoreCache.getScores();
  }
}
