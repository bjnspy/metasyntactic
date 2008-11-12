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

import android.os.RemoteException;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.*;

import java.util.List;

/**
 * Wrapper that throws runtime exceptions instead of remoting exceptions
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class NowPlayingControllerWrapper {
  private final INowPlayingController controller;

  public NowPlayingControllerWrapper(INowPlayingController controller) {
    this.controller = controller;
  }

  public String getUserLocation() {
    try {
      return controller.getUserLocation();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setUserLocation(String userLocation) {
    try {
      controller.setUserLocation(userLocation);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getSearchDistance() {
    try {
      return controller.getSearchDistance();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setSearchDistance(int searchDistance) {
    try {
      controller.setSearchDistance(searchDistance);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getSelectedTabIndex() {
    try {
      return controller.getSelectedTabIndex();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setSelectedTabIndex(int index) {
    try {
      controller.setSelectedTabIndex(index);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getAllMoviesSelectedSortIndex() {
    try {
      return controller.getAllMoviesSelectedSortIndex();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setAllMoviesSelectedSortIndex(int index) {
    try {
      controller.setAllMoviesSelectedSortIndex(index);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getAllTheatersSelectedSortIndex() {
    try {
      return controller.getAllTheatersSelectedSortIndex();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setAllTheatersSelectedSortIndex(int index) {
    try {
      controller.setAllTheatersSelectedSortIndex(index);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    try {
      return controller.getUpcomingMoviesSelectedSortIndex();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setUpcomingMoviesSelectedSortIndex(int index) {
    try {
      controller.setUpcomingMoviesSelectedSortIndex(index);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Movie> getMovies() {
    try {
      return controller.getMovies();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Theater> getTheaters() {
    try {
      return controller.getTheaters();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<String> getTrailers(Movie movie) {
    try {
      return controller.getTrailers(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Review> getReviews(Movie movie) {
    try {
      return controller.getReviews(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public ScoreType getScoreType() {
    try {
      return controller.getScoreType();
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public Score getScore(Movie movie) {
    try {
      return controller.getScore(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public ByteArray getPoster(Movie movie) {
    try {
      return controller.getPoster(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getSynopsis(Movie movie) {
    try {
      return controller.getSynopsis(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getImdbAddress(Movie movie) {
    try {
      return controller.getImdbAddress(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void prioritizeMovie(Movie movie) {
    try {
      controller.prioritizeMovie(movie);
    } catch (RemoteException e) {
      throw new RuntimeException(e);
    }
  }
}
