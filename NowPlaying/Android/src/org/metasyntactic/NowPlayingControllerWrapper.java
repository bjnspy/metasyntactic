package org.metasyntactic;

import android.os.RemoteException;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;

/**
 * Wrapper that throws runtime exceptions instead of remoting exceptions
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class NowPlayingControllerWrapper {
  private final INowPlayingController controller;


  public NowPlayingControllerWrapper(INowPlayingController controller) {
    this.controller = controller;
  }


  public void setUserLocation(String userLocation) {
    try {
      controller.setUserLocation(userLocation);
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
      controller.setAllMoviesSelectedSortIndex(index);
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
}
