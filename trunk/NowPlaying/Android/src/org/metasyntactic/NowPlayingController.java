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
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;
import org.metasyntactic.threading.ThreadingUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Date;
import java.util.List;

public class NowPlayingController {
  private final NowPlayingModel model;
  private final Object lock = new Object();

  public NowPlayingController(final Context applicationContext) {
    this.model = new NowPlayingModel(applicationContext);
  }

  public void startup() {
    this.model.startup();
    update();
  }

  public void shutdown() {
    this.model.shutdown();
  }

  private void update() {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Controller", runnable, this.lock, false/* visible */);
  }

  private void updateBackgroundEntryPoint() {
    if (isNullOrEmpty(this.model.getUserAddress())) {
      return;
    }
    final Location location = this.model.getUserLocationCache()
        .downloadUserAddressLocationBackgroundEntryPoint(this.model.getUserAddress());
    if (location == null) {
      ThreadingUtilities.performOnMainThread(new Runnable() {
        public void run() {
          reportUnknownLocation();
        }
      });
    } else {
      this.model.update();
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
    return this.model.getUserAddress();
  }

  public void setUserAddress(final String userAddress) {
    if (getUserAddress().equals(userAddress)) {
      return;
    }
    this.model.setUserAddress(userAddress);
    update();
    Application.refresh(true);
  }

  public Location getLocationForAddress(final String address) {
    return this.model.getUserLocationCache().locationForUserAddress(address);
  }

  public int getSearchDistance() {
    return this.model.getSearchDistance();
  }

  public void setSearchDistance(final int searchDistance) {
    this.model.setSearchDistance(searchDistance);
  }

  public int getSelectedTabIndex() {
    return this.model.getSelectedTabIndex();
  }

  public void setSelectedTabIndex(final int index) {
    this.model.setSelectedTabIndex(index);
  }

  public int getAllMoviesSelectedSortIndex() {
    return this.model.getAllMoviesSelecetedSortIndex();
  }

  public void setAllMoviesSelectedSortIndex(final int index) {
    this.model.setAllMoviesSelectedSortIndex(index);
  }

  public int getAllTheatersSelectedSortIndex() {
    return this.model.getAllTheatersSelectedSortIndex();
  }

  public void setAllTheatersSelectedSortIndex(final int index) {
    this.model.setAllTheatersSelectedSortIndex(index);
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    return this.model.getUpcomingMoviesSelectedSortIndex();
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) {
    this.model.setUpcomingMoviesSelectedSortIndex(index);
  }

  public List<Movie> getMovies() {
    return this.model.getMovies();
  }

  public List<Theater> getTheaters() {
    return this.model.getTheaters();
  }

  public String getTrailer(final Movie movie) {
    return this.model.getTrailer(movie);
  }

  public List<Review> getReviews(final Movie movie) {
    return this.model.getReviews(movie);
  }

  public String getIMDbAddress(final Movie movie) {
    return this.model.getIMDbAddress(movie);
  }

  public List<Theater> getTheatersShowingMovie(final Movie movie) {
    return this.model.getTheatersShowingMovie(movie);
  }

  public List<Movie> getMoviesAtTheater(final Theater theater) {
    return this.model.getMoviesAtTheater(theater);
  }

  public List<Performance> getPerformancesForMovieAtTheater(final Movie movie, final Theater theater) {
    return this.model.getPerformancesForMovieAtTheater(movie, theater);
  }

  public ScoreType getScoreType() {
    return this.model.getScoreType();
  }

  public void setScoreType(final ScoreType scoreType) {
    this.model.setScoreType(scoreType);
    update();
  }

  public Score getScore(final Movie movie) {
    return this.model.getScore(movie);
  }

  public byte[] getPoster(final Movie movie) {
    return this.model.getPoster(movie);
  }

  public File getPosterFile_safeToCallFromBackground(final Movie movie) {
    return this.model.getPosterFile_safeToCallFromBackground(movie);
  }

  public String getSynopsis(final Movie movie) {
    return this.model.getSynopsis(movie);
  }

  public void prioritizeMovie(final Movie movie) {
    this.model.prioritizeMovie(movie);
  }

  public boolean isAutoUpdateEnabled() {
    return this.model.isAutoUpdateEnabled();
  }

  public void setAutoUpdateEnabled(final boolean enabled) {
    this.model.setAutoUpdateEnabled(enabled);
  }

  public Date getSearchDate() {
    return this.model.getSearchDate();
  }

  public void setSearchDate(final Date date) {
    this.model.setSearchDate(date);
    update();
  }

  public void reportLocationForAddress(final Location location, final String displayString) {
    this.model.reportLocationForAddress(location, displayString);
  }

  public List<Movie> getUpcomingMovies() {
    return this.model.getUpcomingMovies();
  }
}
