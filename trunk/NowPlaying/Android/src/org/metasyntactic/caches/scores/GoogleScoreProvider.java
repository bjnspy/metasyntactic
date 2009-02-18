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
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.caches.UserLocationCache;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Score;
import org.metasyntactic.protobuf.NowPlaying;
import org.metasyntactic.time.Days;
import org.metasyntactic.utilities.ExceptionUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import static java.lang.Math.max;
import static java.lang.Math.min;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class GoogleScoreProvider extends AbstractScoreProvider {
  public GoogleScoreProvider(final NowPlayingModel model) {
    super(model);
  }

  @Override protected String getProviderName() {
    return "Google";
  }

  private String getUrl() {
    final Location location = UserLocationCache.downloadUserAddressLocationBackgroundEntryPoint(
        getModel().getUserAddress());

    if (location == null || isNullOrEmpty(location.getPostalCode())) {
      return null;
    }

    final String country = isNullOrEmpty(
        location.getCountry()) ? Locale.getDefault().getCountry() : location.getCountry();

    //Debug.startMethodTracing("getUrlDaysBetween", 1 << 24);
    int days = Days.daysBetween(new Date(), getModel().getSearchDate());
    //Debug.stopMethodTracing();
    days = min(max(days, 0), 7);

    return "http://" + NowPlayingApplication.host + ".appspot.com/LookupTheaterListings2?country=" + country + "&language=" + Locale.getDefault().getLanguage() + "&day=" + days + "&format=pb" + "&latitude=" + (int) (location.getLatitude() * 1000000) + "&longitude=" + (int) (location.getLongitude() * 1000000);
  }

  @Override protected String lookupServerHash() {
    String address = getUrl();
    if (isNullOrEmpty(address)) {
      return address;
    }
    address += "&hash=true";
    return NetworkUtilities.downloadString(address, true);
  }

  @Override protected Map<String, Score> lookupServerScores() {
    final String address = getUrl();
    if (isNullOrEmpty(address)) {
      return Collections.emptyMap();
    }
    final byte[] data = NetworkUtilities.download(address, true);

    if (data != null) {
      final NowPlaying.TheaterListingsProto theaterListings;
      try {
        theaterListings = NowPlaying.TheaterListingsProto.parseFrom(data);
      } catch (final InvalidProtocolBufferException e) {
        ExceptionUtilities.log(GoogleScoreProvider.class, "lookupServerRatings", e);
        return null;
      }

      final Map<String, Score> ratings = new HashMap<String, Score>();

      for (final NowPlaying.MovieProto movieProto : theaterListings.getMoviesList()) {
        final String identifier = movieProto.getIdentifier();
        final String title = movieProto.getTitle();
        int value = -1;
        if (movieProto.hasScore()) {
          value = movieProto.getScore();
        }

        final Score score = new Score(title, "", String.valueOf(value), "google", identifier);
        ratings.put(score.getCanonicalTitle(), score);
      }

      return ratings;
    }

    return null;
  }
}
