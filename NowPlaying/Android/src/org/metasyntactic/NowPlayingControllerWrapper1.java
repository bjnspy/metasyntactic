// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic;

import android.app.Activity;
import android.content.Context;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;
import org.metasyntactic.ui.GlobalActivityIndicator;
import org.metasyntactic.utilities.SetUtilities;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingControllerWrapper1 {
  private static final Object lock = new Object();

  private static final Set<Activity> activities = new LinkedHashSet<Activity>();
  private static NowPlayingController1 instance;

  private NowPlayingControllerWrapper1() {

  }

  public static void addActivity(Activity activity) {
    synchronized (lock) {
      activities.add(activity);
      GlobalActivityIndicator.addActivity(activity);

      if (activities.size() == 1) {
        instance = new NowPlayingController1();
        instance.startup();
      }
    }
  }

  public static void removeActivity(Activity activity) {
    synchronized (lock) {
      GlobalActivityIndicator.removeActivity(activity);
      activities.remove(activity);

      if (activities.size() == 0) {
        instance.shutdown();
        instance = null;
      }
    }
  }

  private static void checkInstance() {
    if (instance == null) {
      throw new RuntimeException("Trying to call into the controller when it does not exist");
    }
  }


  public static Context getApplicationContext() {
    synchronized (lock) {
      checkInstance();
      return SetUtilities.any(activities).getApplicationContext();
    }
  }


  public static String getUserLocation() {
    synchronized (lock) {
      checkInstance();
      return instance.getUserLocation();
    }
  }

  public static void setUserLocation(String userLocation) {
    synchronized (lock) {
      checkInstance();
      instance.setUserLocation(userLocation);
    }
  }

  public static int getSearchDistance() {

    synchronized (lock) {
      checkInstance();
      return instance.getSearchDistance();
    }
  }

  public static void setSearchDistance(int searchDistance) {
    synchronized (lock) {
      checkInstance();
      instance.setSearchDistance(searchDistance);
    }
  }

  public static int getSelectedTabIndex() {
    synchronized (lock) {
      checkInstance();
      return instance.getSelectedTabIndex();
    }
  }

  public static void setSelectedTabIndex(int index) {
    synchronized (lock) {
      checkInstance();
      instance.setSelectedTabIndex(index);
    }
  }

  public static int getAllMoviesSelectedSortIndex() {
    synchronized (lock) {
      checkInstance();
      return instance.getAllMoviesSelectedSortIndex();
    }
  }

  public static void setAllMoviesSelectedSortIndex(int index) {
    synchronized (lock) {
      checkInstance();
      instance.setAllMoviesSelectedSortIndex(index);
    }
  }

  public static int getAllTheatersSelectedSortIndex() {
    synchronized (lock) {
      checkInstance();
      return instance.getAllTheatersSelectedSortIndex();
    }
  }

  public static void setAllTheatersSelectedSortIndex(int index) {
    synchronized (lock) {
      checkInstance();
      instance.setAllTheatersSelectedSortIndex(index);
    }
  }

  public static int getUpcomingMoviesSelectedSortIndex() {
    synchronized (lock) {
      checkInstance();
      return instance.getUpcomingMoviesSelectedSortIndex();
    }
  }

  public static void setUpcomingMoviesSelectedSortIndex(int index) {
    synchronized (lock) {
      checkInstance();
      instance.setUpcomingMoviesSelectedSortIndex(index);
    }
  }

  public static List<Movie> getMovies() {
    synchronized (lock) {
      checkInstance();
      return instance.getMovies();
    }
  }

  public static List<Theater> getTheaters() {
    synchronized (lock) {
      checkInstance();
      return instance.getTheaters();
    }
  }

  public static List<String> getTrailers(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getTrailers(movie);
    }
  }

  public static List<Review> getReviews(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getReviews(movie);
    }
  }

  public static String getImdbAddress(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getImdbAddress(movie);
    }
  }

  public static List<Theater> getTheatersShowingMovie(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getTheatersShowingMovie(movie);
    }
  }

  public static List<Movie> getMoviesAtTheater(Theater theater) {
    synchronized (lock) {
      checkInstance();
      return instance.getMoviesAtTheater(theater);
    }
  }

  public static List<Performance> getPerformancesForMovieAtTheater(Movie movie, Theater theater) {
    synchronized (lock) {
      checkInstance();
      return instance.getPerformancesForMovieAtTheater(movie, theater);
    }
  }

  public static ScoreType getScoreType() {
    synchronized (lock) {
      checkInstance();
      return instance.getScoreType();
    }
  }

  public static void setScoreType(ScoreType scoreType) {
    synchronized (lock) {
      checkInstance();
      instance.setScoreType(scoreType);
    }
  }

  public static Score getScore(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getScore(movie);
    }
  }

  public static ByteArray getPoster(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getPoster(movie);
    }
  }

  public static String getSynopsis(Movie movie) {
    synchronized (lock) {
      checkInstance();
      return instance.getSynopsis(movie);
    }
  }

  public static void prioritizeMovie(Movie movie) {
    synchronized (lock) {
      checkInstance();
      instance.prioritizeMovie(movie);
    }
  }
}
