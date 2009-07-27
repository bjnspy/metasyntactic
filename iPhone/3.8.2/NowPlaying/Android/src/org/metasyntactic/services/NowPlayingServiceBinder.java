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

import android.os.RemoteException;

public class NowPlayingServiceBinder extends INowPlayingService.Stub {
  private final NowPlayingService service;

  public NowPlayingServiceBinder(final NowPlayingService service) {
    this.service = service;
  }

  public String getUserAddress() throws RemoteException {
    return service.getUserAddress();
  }

  public void setUserAddress(final String address) throws RemoteException {
    service.setUserAddress(address);
  }

  public Location getLocationForAddress(final String address) throws RemoteException {
    return NowPlayingService.getLocationForAddress(address);
  }

  public int getSearchDistance() throws RemoteException {
    return service.getSearchDistance();
  }

  public void setSearchDistance(final int distance) throws RemoteException {
    service.setSearchDistance(distance);
  }

  public int getSelectedTabIndex() throws RemoteException {
    return service.getSelectedTabIndex();
  }

  public void setSelectedTabIndex(final int index) throws RemoteException {
    service.setSelectedTabIndex(index);
  }

  public int getAllMoviesSelectedSortIndex() throws RemoteException {
    return service.getAllMoviesSelectedSortIndex();
  }

  public void setAllMoviesSelectedSortIndex(final int index) throws RemoteException {
    service.setAllMoviesSelectedSortIndex(index);
  }

  public int getAllTheatersSelectedSortIndex() throws RemoteException {
    return service.getAllTheatersSelectedSortIndex();
  }

  public void setAllTheatersSelectedSortIndex(final int index) throws RemoteException {
    service.setAllTheatersSelectedSortIndex(index);
  }

  public int getUpcomingMoviesSelectedSortIndex() throws RemoteException {
    return service.getUpcomingMoviesSelectedSortIndex();
  }

  public void setUpcomingMoviesSelectedSortIndex(final int index) throws RemoteException {
    service.setUpcomingMoviesSelectedSortIndex(index);
  }

  public List<Movie> getMovies() throws RemoteException {
    return service.getMovies();
  }

  public List<Theater> getTheaters() throws RemoteException {
    return service.getTheaters();
  }

  public String getTrailer(final Movie movie) throws RemoteException {
    return NowPlayingService.getTrailer(movie);
  }

  public List<Review> getReviews(final Movie movie) throws RemoteException {
    return service.getReviews(movie);
  }

  public String getAmazonAddress(final Movie movie) throws RemoteException {
    return NowPlayingService.getAmazonAddress(movie);
  }

  public String getIMDbAddress(final Movie movie) throws RemoteException {
    return NowPlayingService.getIMDbAddress(movie);
  }

  public String getWikipediaAddress(final Movie movie) throws RemoteException {
    return NowPlayingService.getWikipediaAddress(movie);
  }

  public List<Theater> getTheatersShowingMovie(final Movie movie) throws RemoteException {
    return service.getTheatersShowingMovie(movie);
  }

  public List<Movie> getMoviesAtTheater(final Theater theater) throws RemoteException {
    return service.getMoviesAtTheater(theater);
  }

  public List<Performance> getPerformancesForMovieAtTheater(final Movie movie, final Theater theater) throws RemoteException {
    return service.getPerformancesForMovieAtTheater(movie, theater);
  }

  public String getScoreType() throws RemoteException {
    return service.getScoreType().toString();
  }

  public void setScoreType(final String scoreType) throws RemoteException {
    service.setScoreType(ScoreType.valueOf(scoreType));
  }

  public Score getScore(final Movie movie) throws RemoteException {
    return service.getScore(movie);
  }

  public byte[] getPoster(final Movie movie) throws RemoteException {
    return NowPlayingService.getPoster(movie);
  }

  public String getPosterFile_safeToCallFromBackground(final Movie movie) throws RemoteException {
    final File file = NowPlayingService.getPosterFile_safeToCallFromBackground(movie);
    if (file == null) {
      return null;
    }

    return file.getPath();
  }

  public String getSynopsis(final Movie movie) throws RemoteException {
    return service.getSynopsis(movie);
  }

  public void prioritizeMovie(final Movie movie) throws RemoteException {
    service.prioritizeMovie(movie);
  }

  public boolean isAutoUpdateEnabled() throws RemoteException {
    return service.isAutoUpdateEnabled();
  }

  public void setAutoUpdateEnabled(final boolean enabled) throws RemoteException {
    service.setAutoUpdateEnabled(enabled);
  }

  public long getSearchDate() throws RemoteException {
    final Date date = service.getSearchDate();
    if (date == null) {
      return -1;
    }

    return date.getTime();
  }

  public void setSearchDate(final long date) throws RemoteException {
    Date searchDate = null;
    if (date != -1) {
      searchDate = new Date(date);
    }

    service.setSearchDate(searchDate);
  }

  public List<Movie> getUpcomingMovies() throws RemoteException {
    return service.getUpcomingMovies();
  }

  public String getDataProviderState() throws RemoteException {
    return service.getDataProviderState().toString();
  }

  public boolean isStale(final Theater theater) throws RemoteException {
    return service.isStale(theater);
  }

  public String getShowtimesRetrievedOnString(final Theater theater) throws RemoteException {
    return service.getShowtimesRetrievedOnString(theater);
  }

  public void addFavoriteTheater(final Theater theater) throws RemoteException {
    service.addFavoriteTheater(theater);
  }

  public void removeFavoriteTheater(final Theater theater) throws RemoteException {
    service.removeFavoriteTheater(theater);
  }

  public boolean isFavoriteTheater(final Theater theater) throws RemoteException {
    return service.isFavoriteTheater(theater);
  }
}
