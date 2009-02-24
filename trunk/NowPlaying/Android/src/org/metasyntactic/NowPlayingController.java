//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,th
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.
package org.metasyntactic;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import org.metasyntactic.activities.R;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.threading.ThreadingUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Date;
import java.util.List;

public class NowPlayingController {
  private final NowPlayingModel model;
  private final Object lock = new Object();

  public NowPlayingController(final Context applicationContext) {
    model = new NowPlayingModel(applicationContext);
  }

  public void startup() {
    model.startup();
    update();
  }

  public void shutdown() {
    model.shutdown();
  }

  private void update() {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Controller", runnable, lock, false/* visible */);
  }

  private void updateBackgroundEntryPoint() {
    if (isNullOrEmpty(model.getUserAddress())) {
      return;
    }
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(model.getUserAddress());
    if (location == null) {
      ThreadingUtilities.performOnMainThread(new Runnable() {
        public void run() {
          reportUnknownLocation();
        }
      });
    } else {
      model.update();
    }
  }

  private static void reportUnknownLocation() {
    final Context context = NowPlayingControllerWrapper.tryGetApplicationContext();
    if (context == null) {
      return;
    }
    new AlertDialog.Builder(context).setMessage(R.string.could_not_find_location_dot)
      .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
        public void onClick(final DialogInterface dialogInterface, final int i) {
        }
      }).show();
  }

  public String getUserAddress() {
    return model.getUserAddress();
  }

  public void setUserAddress(final String userAddress) {
    if (getUserAddress().equals(userAddress)) {
      return;
    }
    model.setUserAddress(userAddress);
    update();
    NowPlayingApplication.refresh(true);
  }

  public static Location getLocationForAddress(final String address) {
    return UserLocationCache.locationForUserAddress(address);
  }

  public int getSearchDistance() {
    return model.getSearchDistance();
  }

  public void setSearchDistance(final int searchDistance) {
    model.setSearchDistance(searchDistance);
  }

  public int getSelectedTabIndex() {
    return model.getSelectedTabIndex();
  }

  public void setSelectedTabIndex(final int index) {
    model.setSelectedTabIndex(index);
  }

  public int getAllMoviesSelectedSortIndex() {
    return model.getAllMoviesSelecetedSortIndex();
  }

  public void setAllMoviesSelectedSortIndex(final int index) {
    model.setAllMoviesSelectedSortIndex(index);
  }

  public int getAllTheatersSelectedSortIndex() {
    return model.getAllTheatersSelectedSortIndex();
  }

  public void setAllTheatersSelectedSortIndex(final int index) {
    model.setAllTheatersSelectedSortIndex(index);
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    return model.getUpcomingMoviesSelectedSortIndex();
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) {
    model.setUpcomingMoviesSelectedSortIndex(index);
  }

  public List<Movie> getMovies() {
    return model.getMovies();
  }

  public List<Theater> getTheaters() {
    return model.getTheaters();
  }

  public static String getTrailer(final Movie movie) {
    return NowPlayingModel.getTrailer(movie);
  }

  public List<Review> getReviews(final Movie movie) {
    return model.getReviews(movie);
  }

  public static String getIMDbAddress(final Movie movie) {
    return NowPlayingModel.getIMDbAddress(movie);
  }

  public List<Theater> getTheatersShowingMovie(final Movie movie) {
    return model.getTheatersShowingMovie(movie);
  }

  public List<Movie> getMoviesAtTheater(final Theater theater) {
    return model.getMoviesAtTheater(theater);
  }

  public List<Performance> getPerformancesForMovieAtTheater(final Movie movie, final Theater theater) {
    return model.getPerformancesForMovieAtTheater(movie, theater);
  }

  public ScoreType getScoreType() {
    return model.getScoreType();
  }

  public void setScoreType(final ScoreType scoreType) {
    model.setScoreType(scoreType);
    update();
  }

  public Score getScore(final Movie movie) {
    return model.getScore(movie);
  }

  public static byte[] getPoster(final Movie movie) {
    return NowPlayingModel.getPoster(movie);
  }

  public static File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return NowPlayingModel.getPosterFile_safeToCallFromBackground(movie);
  }

  public String getSynopsis(final Movie movie) {
    return model.getSynopsis(movie);
  }

  public void prioritizeMovie(final Movie movie) {
    model.prioritizeMovie(movie);
  }

  public boolean isAutoUpdateEnabled() {
    return model.isAutoUpdateEnabled();
  }

  public void setAutoUpdateEnabled(final boolean enabled) {
    model.setAutoUpdateEnabled(enabled);
  }

  public Date getSearchDate() {
    return model.getSearchDate();
  }

  public void setSearchDate(final Date date) {
    model.setSearchDate(date);
    update();
  }

  public static void reportLocationForAddress(final Location location, final String displayString) {
    NowPlayingModel.reportLocationForAddress(location, displayString);
  }

  public List<Movie> getUpcomingMovies() {
    return model.getUpcomingMovies();
  }

  public void onLowMemory() {
    model.onLowMemory();
  }

  public DataProvider.State getDataProviderState() {
    return model.getDataProviderState();
  }
}
