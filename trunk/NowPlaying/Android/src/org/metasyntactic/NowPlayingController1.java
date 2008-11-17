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

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.List;

public class NowPlayingController1 {
  private final NowPlayingModel model = new NowPlayingModel();
  private final Object lock = new Object();

  public NowPlayingController1() {

  }

  public void startup() {
    update();
  }

  public void shutdown() {}

  private void update() {
    Runnable runnable = new Runnable() {
      public void run() {
        model.update();
      }
    };

    ThreadingUtilities.performOnBackgroundThread("Update Model", runnable, lock, false/* visible */);
  }

  public String getUserLocation() {
    return model.getUserLocation();
  }

  public void setUserLocation(String userLocation) {
    model.setUserLocation(userLocation);
    update();
  }

  public int getSearchDistance() {
    return model.getSearchDistance();
  }

  public void setSearchDistance(int searchDistance) {
    model.setSearchDistance(searchDistance);
  }

  public int getSelectedTabIndex() {
    return model.getSelectedTabIndex();
  }

  public void setSelectedTabIndex(int index) {
    model.setSelectedTabIndex(index);
  }

  public int getAllMoviesSelectedSortIndex() {
    return model.getAllMoviesSelecetedSortIndex();
  }

  public void setAllMoviesSelectedSortIndex(int index) {
    model.setAllMoviesSelectedSortIndex(index);
  }

  public int getAllTheatersSelectedSortIndex() {
    return model.getAllTheatersSelectedSortIndex();
  }

  public void setAllTheatersSelectedSortIndex(int index) {
    model.setAllTheatersSelectedSortIndex(index);
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    return model.getUpcomingMoviesSelectedSortIndex();
  }

  public void setUpcomingMoviesSelectedSortIndex(int index) {
    model.setUpcomingMoviesSelectedSortIndex(index);
  }

  public List<Movie> getMovies() {
    return model.getMovies();
  }

  public List<Theater> getTheaters() {
    return model.getTheaters();
  }

  public List<String> getTrailers(Movie movie) {
    return model.getTrailers(movie);
  }

  public List<Review> getReviews(Movie movie) {
    return model.getReviews(movie);
  }

  public String getImdbAddress(Movie movie) {
    return model.getImdbAddress(movie);
  }

  public List<Theater> getTheatersShowingMovie(Movie movie) {
    return model.getTheatersShowingMovie(movie);
  }

  public List<Movie> getMoviesAtTheater(Theater theater) {
    return model.getMoviesAtTheater(theater);
  }

  public List<Performance> getPerformancesForMovieAtTheater(Movie movie, Theater theater) {
    return model.getPerformancesForMovieAtTheater(movie, theater);
  }

  public ScoreType getScoreType() {
    return model.getScoreType();
  }

  public void setScoreType(ScoreType scoreType) {
    model.setScoreType(scoreType);
    update();
  }

  public Score getScore(Movie movie) {
    return model.getScore(movie);
  }

  public ByteArray getPoster(Movie movie) {
    byte[] bytes = model.getPoster(movie);
    if (bytes == null) {
      return ByteArray.empty;
    }

    return new ByteArray(bytes);
  }

  public String getSynopsis(Movie movie) {
    return model.getSynopsis(movie);
  }

  public void prioritizeMovie(Movie movie) {
    model.prioritizeMovie(movie);
  }
}
