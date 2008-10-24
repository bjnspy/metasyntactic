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

package org.metasyntactic.caches.scores;

import com.google.protobuf.InvalidProtocolBufferException;
import org.metasyntactic.Application;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Score;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.time.Days;
import org.metasyntactic.utilities.ExceptionUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import static java.lang.Math.max;
import static java.lang.Math.min;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class GoogleScoreProvider extends AbstractScoreProvider {
  public GoogleScoreProvider(ScoreCache scoreCache) {
    super(scoreCache);
  }


  @Override
  protected String getProviderName() {
    return "Google";
  }


  private String getUrl() {
    Location location = getModel().getUserLocationCache().downloadUserAddressLocationBackgroundEntryPoint(
        getModel().getUserLocation());

    if (StringUtilities.isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    String country = isNullOrEmpty(location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();

    //Debug.startMethodTracing("getUrlDaysBetween", 1 << 24);
    int days = Days.daysBetween(new Date(), getModel().getSearchDate());
    //Debug.stopMethodTracing();
    days = min(max(days, 0), 7);

    String address = "http://" + Application.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&language="
        + Locale.getDefault().getLanguage() + "&day=" + days + "&format=pb" + "&latitude="
        + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location.getLongitude() * 1000000);

    return address;
  }


  @Override
  protected String lookupServerHash() {
    String address = getUrl();
    address += "&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }


  @Override
  protected Map<String, Score> lookupServerRatings() {
    String address = getUrl();
    byte[] data = NetworkUtilities.download(address, true);

    if (data != null) {
      NowPlaying.TheaterListingsProto theaterListings = null;
      try {
        theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
      } catch (InvalidProtocolBufferException e) {
        ExceptionUtilities.log(GoogleScoreProvider.class, "lookupServerRatings", e);
        return null;
      }

      Map<String, Score> ratings = new HashMap<String, Score>();

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
