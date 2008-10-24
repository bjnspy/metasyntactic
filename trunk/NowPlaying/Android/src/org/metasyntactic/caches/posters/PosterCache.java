package org.metasyntactic.caches.posters;

import org.metasyntactic.Application;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
    List<Movie> moviesWithPosterLinks = new ArrayList<Movie>();
    List<Movie> moviesWithoutPosterLinks = new ArrayList<Movie>();

    for (Movie movie : movies) {
      if (StringUtilities.isNullOrEmpty(movie.getPoster())) {
        moviesWithoutPosterLinks.add(movie);
      } else {
        moviesWithPosterLinks.add(movie);
      }
    }

    Location location = model.getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        model.getUserLocation());

    String postalCode = location == null ? "10009" : location.getPostalCode();
    if (postalCode == null || !"US".equals(location.getCountry())) {
      postalCode = "10009";
    }

    for (List<Movie> list : Arrays.asList(moviesWithPosterLinks, moviesWithoutPosterLinks)) {
      for (Movie movie : list) {
        downloadPoster(movie, postalCode);
      }
    }
  }


  private void downloadPoster(Movie movie, String postalCode) {
    File file = posterFile(movie);
    if (file.exists()) {
      return;
    }

    byte[] bytes = downloadPosterWorker(movie, postalCode);
    if (bytes != null) {
      FileUtilities.writeBytes(bytes, file);
      Application.refresh();
    }
  }



  private byte[] downloadPosterWorker(Movie movie, String postalCode) {
    byte[] data = NetworkUtilities.download(movie.getPoster(), false);
    if (data != null) {
      return data;
    }

    data = ApplePosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    data = FandangoPosterDownloader.download(movie, postalCode);
    if (data != null) {
      return data;
    }

    data = ImdbPosterDownloader.download(movie);
    if (data != null) {
      return data;
    }

    return null;
  }


  private void deleteObsoletePosters(List<Movie> movies) {

  }
}
