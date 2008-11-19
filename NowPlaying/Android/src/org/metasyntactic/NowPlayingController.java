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
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;
import org.metasyntactic.threading.ThreadingUtilities;

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
        NowPlayingController.this.model.update();
      }
    };

    ThreadingUtilities.performOnBackgroundThread("Update Model", runnable, this.lock, false/* visible */);
  }

  public String getUserLocation() {
    return this.model.getUserLocation();
  }

  public void setUserLocation(final String userLocation) {
    this.model.setUserLocation(userLocation);
    update();
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

  public List<String> getTrailers(final Movie movie) {
    return this.model.getTrailers(movie);
  }

  public List<Review> getReviews(final Movie movie) {
    return this.model.getReviews(movie);
  }

  public String getImdbAddress(final Movie movie) {
    return this.model.getImdbAddress(movie);
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

  public String getSynopsis(final Movie movie) {
    return this.model.getSynopsis(movie);
  }

  public void prioritizeMovie(final Movie movie) {
    this.model.prioritizeMovie(movie);
  }

  public boolean isAutoUpdateEnabled() {
    return this.model.isAutoUpdateEnabled();
  }

  public void setAutoUpdateEnabled(boolean enabled) {
    this.model.setAutoUpdateEnabled(enabled);
  }

  public Date getSearchDate() {
    return this.model.getSearchDate();
  }

  public void setSearchDate(Date date) {
    this.model.setSearchDate(date);
    update();
  }
}
