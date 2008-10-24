package org.metasyntactic.caches.posters;

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.io.File;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PosterCache {
  private final Object lock = new Object();
  private final NowPlayingModel model;


  public PosterCache(NowPlayingModel model) {
    this.model = model;
  }


  private File posterFile(Movie movie) {
    return new File(Application.postersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }


  public void update(final List<Movie> movies) {
    Runnable runnable = new Runnable() {
      public void run() {
        updateBackgroundEntryPoint(movies);
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Update Posters", runnable, lock, false);
  }


  private void updateBackgroundEntryPoint(List<Movie> movies) {
    deleteObsoletePosters(movies);
    downloadPosters(movies);
  }


  private void downloadPosters(List<Movie> movies) {
    Set<Movie> moviesSet = new HashSet<Movie>();
    for (Movie movie : movies) {
      if (!posterFile(movie).exists()) {
        moviesSet.add(movie);
      }
    }

    long start = System.currentTimeMillis();
    downloadPostersWithLinks(moviesSet);
    LogUtilities.logTime(PosterCache.class, "Download Posters - Links", start);

    start = System.currentTimeMillis();
    downloadApplePosters(moviesSet);
    LogUtilities.logTime(PosterCache.class, "Download Posters - Apple", start);

    start = System.currentTimeMillis();
    downloadFandangoPosters(moviesSet);
    LogUtilities.logTime(PosterCache.class, "Download Posters - Fandango", start);

    start = System.currentTimeMillis();
    downloadImdbPosters(moviesSet);
    LogUtilities.logTime(PosterCache.class, "Download Posters - IMDb", start);
  }


  private void checkData(Iterator<Movie> i, Movie movie, byte[] data) {
    if (data != null) {
      i.remove();
      FileUtilities.writeBytes(data, posterFile(movie));
      Application.refresh();
    }
  }


  private void downloadPostersWithLinks(Set<Movie> moviesSet) {
    for (Iterator<Movie> i = moviesSet.iterator(); i.hasNext();) {
      Movie movie = i.next();

      byte[] data = NetworkUtilities.download(movie.getPoster(), false);
      checkData(i, movie, data);
    }
  }


  private void downloadApplePosters(Set<Movie> moviesSet) {
    for (Iterator<Movie> i = moviesSet.iterator(); i.hasNext();) {
      Movie movie = i.next();

      byte[] data = ApplePosterDownloader.download(movie);
      checkData(i, movie, data);
    }
  }


  private void downloadFandangoPosters(Set<Movie> moviesSet) {
    Location location = model.getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        model.getUserLocation());

    String country = location == null ? "" : location.getCountry();
    String postalCode = location == null ? "10009" : location.getPostalCode();

    if (StringUtilities.isNullOrEmpty(postalCode) || !"US".equals(country)) {
      postalCode = "10009";
    }

    for (Iterator<Movie> i = moviesSet.iterator(); i.hasNext();) {
      Movie movie = i.next();

      byte[] data = FandangoPosterDownloader.download(movie, postalCode);
      checkData(i, movie, data);
    }
  }


  private void downloadImdbPosters(Set<Movie> moviesSet) {
    for (Iterator<Movie> i = moviesSet.iterator(); i.hasNext();) {
      Movie movie = i.next();

      byte[] data = ImdbPosterDownloader.download(movie);
      checkData(i, movie, data);
    }
  }


  private void deleteObsoletePosters(List<Movie> movies) {

  }
}
