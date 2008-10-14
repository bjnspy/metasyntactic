package org.metasyntactic;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.List;

public class NowPlayingControllerService extends Service {
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


  private final INowPlayingController.Stub binder = new INowPlayingController.Stub() {
    public String getUserLocation() throws RemoteException {
      return NowPlayingControllerService.this.getUserLocation();
    }


    public void setUserLocation(String userLocation) throws RemoteException {
      NowPlayingControllerService.this.setUserLocation(userLocation);
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
  };


  public String getUserLocation() {
    return model.getUserLocation();
  }


  public void setUserLocation(String userLocation) {
    model.setUserLocation(userLocation);
    update();
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
}
