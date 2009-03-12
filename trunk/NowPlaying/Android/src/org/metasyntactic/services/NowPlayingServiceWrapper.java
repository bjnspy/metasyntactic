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
package org.metasyntactic.services;

import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.io.File;
import java.util.Date;
import java.util.List;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.providers.DataProvider;

import android.os.RemoteException;

public class NowPlayingServiceWrapper {
  private final INowPlayingService service;

  public NowPlayingServiceWrapper(final INowPlayingService service) {
    this.service = service;
  }

  public String getUserAddress() {
    try {
      return service.getUserAddress();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setUserAddress(final String address) {
    try {
      service.setUserAddress(address);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public Location getLocationForAddress(final String address) {
    try {
      return service.getLocationForAddress(address);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }


  public int getSearchDistance() {
    try {
      return service.getSearchDistance();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setSearchDistance(final int distance) {
    try {
      service.setSearchDistance(distance);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getSelectedTabIndex() {
    try {
      return service.getSelectedTabIndex();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setSelectedTabIndex(final int index) {
    try {
      service.setSelectedTabIndex(index);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getAllMoviesSelectedSortIndex() {
    try {
      return service.getAllMoviesSelectedSortIndex();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setAllMoviesSelectedSortIndex(final int index) {
    try {
      service.setAllMoviesSelectedSortIndex(index);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getAllTheatersSelectedSortIndex() {
    try {
      return service.getAllTheatersSelectedSortIndex();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setAllTheatersSelectedSortIndex(final int index) {
    try {
      service.setAllTheatersSelectedSortIndex(index);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public int getUpcomingMoviesSelectedSortIndex() {
    try {
      return service.getUpcomingMoviesSelectedSortIndex();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) {
    try {
      service.setUpcomingMoviesSelectedSortIndex(index);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Movie> getMovies() {
    try {
      return service.getMovies();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Theater> getTheaters() {
    try {
      return service.getTheaters();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getTrailer(final Movie movie) {
    try {
      return service.getTrailer(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Review> getReviews(final Movie movie) {
    try {
      return service.getReviews(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getAmazonAddress(final Movie movie) {
    try {
      return service.getAmazonAddress(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getIMDbAddress(final Movie movie) {
    try {
      return service.getIMDbAddress(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getWikipediaAddress(final Movie movie) {
    try {
      return service.getWikipediaAddress(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Theater> getTheatersShowingMovie(final Movie movie) {
    try {
      return service.getTheatersShowingMovie(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Movie> getMoviesAtTheater(final Theater theater) {
    try {
      return service.getMoviesAtTheater(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Performance> getPerformancesForMovieAtTheater(final Movie movie, final Theater theater) {
    try {
      return service.getPerformancesForMovieAtTheater(movie, theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public ScoreType getScoreType() {
    try {
      final String type = service.getScoreType();
      return ScoreType.valueOf(type);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  @SuppressWarnings({"TypeMayBeWeakened"})
  public void setScoreType(final ScoreType scoreType) {
    try {
      service.setScoreType(scoreType.toString());
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public Score getScore(final Movie movie) {
    try {
      return service.getScore(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public byte[] getPoster(final Movie movie) {
    try {
      return service.getPoster(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public File getPosterFile_safeToCallFromBackground(final Movie movie) {
    try {
      final String path = service.getPosterFile_safeToCallFromBackground(movie);
      if (isNullOrEmpty(path)) {
        return null;
      }

      return new File(path);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getSynopsis(final Movie movie) {
    try {
      return service.getSynopsis(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void prioritizeMovie(final Movie movie) {
    try {
      service.prioritizeMovie(movie);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public boolean isAutoUpdateEnabled() {
    try {
      return service.isAutoUpdateEnabled();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setAutoUpdateEnabled(final boolean enabled) {
    try {
      service.setAutoUpdateEnabled(enabled);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public Date getSearchDate() {
    try {
      final long date = service.getSearchDate();
      if (date == -1) {
        return null;
      }

      return new Date(date);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void setSearchDate(final Date date) {
    try {
      service.setSearchDate(date == null ? -1 : date.getTime());
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public List<Movie> getUpcomingMovies() {
    try {
      return service.getUpcomingMovies();
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public DataProvider.State getDataProviderState() {
    try {
      return DataProvider.State.valueOf(service.getDataProviderState());
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public boolean isStale(final Theater theater) {
    try {
      return service.isStale(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public String getShowtimesRetrievedOnString(final Theater theater) {
    try {
      return service.getShowtimesRetrievedOnString(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void addFavoriteTheater(final Theater theater) {
    try {
      service.addFavoriteTheater(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public void removeFavoriteTheater(final Theater theater) {
    try {
      service.removeFavoriteTheater(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }

  public boolean isFavoriteTheater(final Theater theater) {
    try {
      return service.isFavoriteTheater(theater);
    } catch (final RemoteException e) {
      throw new RuntimeException(e);
    }
  }
}
