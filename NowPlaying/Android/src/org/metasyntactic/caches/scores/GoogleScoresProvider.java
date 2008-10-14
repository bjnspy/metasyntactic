package org.metasyntactic.caches.scores;

import com.google.protobuf.InvalidProtocolBufferException;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Score;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.utilities.ExceptionUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import static java.lang.Math.max;
import static java.lang.Math.min;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class GoogleScoresProvider extends AbstractScoresProvider {
  public GoogleScoresProvider(ScoresCache scoresCache) {
    super(scoresCache);
  }


  protected String getProviderName() {
    return "Google";
  }


  private String getUrl() {
    Location location =
        getModel().getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
            getModel().getUserLocation());

    if (StringUtilities.isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    String country = isNullOrEmpty(location.getCountry()) ?
        Locale.getDefault().getCountry() : location.getCountry();

    int days = Days.daysBetween(new DateTime(new Date()), new DateTime(getModel().getSearchDate())).getDays();
    days = min(max(days, 0), 7);

    String address =
        "http://metaboxoffice2.appspot.com/LookupTheaterListings2?country=" + country +
            "&language=" + Locale.getDefault().getLanguage() +
            "&day=" + days +
            "&format=pb" +
            "&latitude=" + (int) (location.getLatitude() * 1000000) +
            "&longitude=" + (int) (location.getLongitude() * 1000000);

    return address;
  }


  protected String lookupServerHash() {
    String address = getUrl();
    address += "&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }


  protected Map<String, Score> lookupServerRatings() {
    String address = getUrl();
    byte[] data = NetworkUtilities.download(address, true);

    if (data != null) {
      NowPlaying.TheaterListingsProto theaterListings = null;
      try {
        theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
      } catch (InvalidProtocolBufferException e) {
        ExceptionUtilities.log(GoogleScoresProvider.class, "lookupServerRatings", e);
        return null;
      }

      Map<String, Score> ratings = new LinkedHashMap<String, Score>();

      for (NowPlaying.MovieProto movieProto : theaterListings.getMoviesList()) {
        String identifier = movieProto.getIdentifier();
        String title = movieProto.getTitle();
        int value = -1;
        if (movieProto.hasScore()) {
          value = movieProto.getScore();
        }

        Score score = new Score(title, "", "" + value, "google", identifier);
        ratings.put(score.getCanonicalTitle(), score);
      }

      return ratings;
    }

    return null;
  }
}
