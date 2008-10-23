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

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.caches.scores.ScoreType;

import java.util.List;

public class NowPlayingControllerService extends Service {
  {
    Application.setContext(this);
  }


  private final NowPlayingModel model = new NowPlayingModel(this);
  private final Object lock = new Object();


  @Override
  public void onCreate() {
    super.onCreate();

    update();
  }


  private void update() {
    Runnable runnable = new Runnable() {
      public void run() {
        model.update();
      }
    };

    ThreadingUtilities.performOnBackgroundThread(runnable, lock, false/*visible*/);
  }


  @Override
  public IBinder onBind(Intent arg0) {
    return binder;
  }


  public String getUserLocation() {
    return model.getUserLocation();
  }


  protected List<String> getTrailers(Movie movie) {
    return model.getTrailers(movie);
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
    return model.getUpcomingMovieSelectedSortIndex();
  }


  public void setUpcomingMoviesSelectedSortIndex(int index) {
    model.setUpcomingMovieSelectedSortIndex(index);
  }


  public List<Movie> getMovies() {
    return model.getMovies();
  }


  public List<Theater> getTheaters() {
    return model.getTheaters();
  }


  private void setScoreType(ScoreType scoreType) {
    model.setScoreType(scoreType);
    update();
  }


  private ScoreType getScoreType() {
    return model.getScoreType();
  }


  private final INowPlayingController.Stub binder = new INowPlayingController.Stub() {
    public String getUserLocation() throws RemoteException {
      return NowPlayingControllerService.this.getUserLocation();
    }


    public void setUserLocation(String userLocation) throws RemoteException {
      NowPlayingControllerService.this.setUserLocation(userLocation);
    }


    public int getSearchDistance() throws RemoteException {
      return NowPlayingControllerService.this.getSearchDistance();
    }


    public void setSearchDistance(int searchDistance) throws RemoteException {
      NowPlayingControllerService.this.setSearchDistance(searchDistance);
    }


    public int getSelectedTabIndex() throws RemoteException {
      return NowPlayingControllerService.this.getSelectedTabIndex();
    }


    public void setSelectedTabIndex(int index) throws RemoteException {
      NowPlayingControllerService.this.setSelectedTabIndex(index);
    }


    public int getAllMoviesSelectedSortIndex() throws RemoteException {
      return NowPlayingControllerService.this.getAllMoviesSelectedSortIndex();
    }


    public void setAllMoviesSelectedSortIndex(int index) throws RemoteException {
      NowPlayingControllerService.this.setAllMoviesSelectedSortIndex(index);
    }


    public int getAllTheatersSelectedSortIndex() throws RemoteException {
      return NowPlayingControllerService.this.getAllTheatersSelectedSortIndex();
    }


    public void setAllTheatersSelectedSortIndex(int index) throws RemoteException {
      NowPlayingControllerService.this.setAllTheatersSelectedSortIndex(index);
    }


    public int getUpcomingMoviesSelectedSortIndex() throws RemoteException {
      return NowPlayingControllerService.this.getUpcomingMoviesSelectedSortIndex();
    }


    public void setUpcomingMoviesSelectedSortIndex(int index) throws RemoteException {
      NowPlayingControllerService.this.setUpcomingMoviesSelectedSortIndex(index);
    }


    public List<Movie> getMovies() throws RemoteException {
      return NowPlayingControllerService.this.getMovies();
    }


    public List<Theater> getTheaters() throws RemoteException {
      return NowPlayingControllerService.this.getTheaters();
    }


    public List<String> getTrailers(Movie movie) throws RemoteException {
      return NowPlayingControllerService.this.getTrailers(movie);
    }


    public ScoreType getScoreType() throws RemoteException {
      return NowPlayingControllerService.this.getScoreType();
    }


    public void setScoreProvider(ScoreType scoreType) throws RemoteException {
      NowPlayingControllerService.this.setScoreType(scoreType);
    }
  };
}
