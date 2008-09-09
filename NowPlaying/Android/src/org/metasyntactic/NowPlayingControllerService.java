package org.metasyntactic;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;

public class NowPlayingControllerService extends Service {
  private final NowPlayingModel model = new NowPlayingModel();

  @Override
  public void onCreate() {
    super.onCreate();

    model.update();
  }

  @Override
  public IBinder onBind(Intent arg0) {
    return binder;
  }

  private final INowPlayingController.Stub binder = new INowPlayingController.Stub() {
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

  public void setUserLocation(String userLocation) throws RemoteException {
  }

  public int getSelectedTabIndex() throws RemoteException {
    return model.getSelectedTabIndex();
  }

  public void setSelectedTabIndex(int index) throws RemoteException {
    model.setSelectedTabIndex(index);
  }

  public int getAllMoviesSelectedSortIndex() throws RemoteException {
    return model.getAllMoviesSelecetedSortIndex();
  }

  public void setAllMoviesSelectedSortIndex(int index) throws RemoteException {
    model.setAllMoviesSelectedSortIndex(index);
  }

  public int getAllTheatersSelectedSortIndex() throws RemoteException {
    return model.getAllTheatersSelectedSortIndex();
  }

  public void setAllTheatersSelectedSortIndex(int index) throws RemoteException {
    model.setAllTheatersSelectedSortIndex();
  }

  public int getUpcomingMoviesSelectedSortIndex() throws RemoteException {
    return model.getUpcomingMovieSelectedSortIndex();
  }

  public void setUpcomingMoviesSelectedSortIndex(int index) throws RemoteException {
    model.setUpcomingMovieSelectedSortIndex(index);
  }

  public List<Movie> getMovies() throws RemoteException {
    return model.getMovies();
  }

  public List<Theater> getTheaters() throws RemoteException {
    return model.getTheaters();
  }
}
