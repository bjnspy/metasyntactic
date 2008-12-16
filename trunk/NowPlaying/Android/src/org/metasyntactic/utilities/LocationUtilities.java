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
package org.metasyntactic.utilities;

import org.metasyntactic.data.Location;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import static org.metasyntactic.utilities.XmlUtilities.element;
import static org.metasyntactic.utilities.XmlUtilities.text;
import org.w3c.dom.Element;

public class LocationUtilities {
  private LocationUtilities() {
  }

  private static Location findLocationWithGeonames(final double latitude, final double longitude) {
    final String url = "http://ws.geonames.org/findNearbyPostalCodes?lat=" + latitude + "&lng=" + longitude + "&maxRows=1";

    final Element geonamesElement = NetworkUtilities.downloadXml(url, true);
    final Element codeElement = element(geonamesElement, "code");
    final String postalCode = text(element(codeElement, "postalcode"));
    final String country = text(element(codeElement, "countryCode"));

    if (isNullOrEmpty(postalCode)) {
      return null;
    }

    if ("CA".equals(country)) {
      return null;
    }

    final String city = text(element(codeElement, "adminName1"));
    final String state = text(element(codeElement, "adminCode1"));

    return new Location(latitude, longitude, "", city, state, postalCode, country);
  }

  private static Location findLocationWithGeocoder(final double latitude, final double longitude) {
    final String url = "http://geocoder.ca/?latt=" + latitude + "&longt=" + longitude + "&geoit=xml&reverse=Reverse+GeoCode+it";

    final Element geodataElement = NetworkUtilities.downloadXml(url, true);
    final String postalCode = text(element(geodataElement, "postal"));

    if (isNullOrEmpty(postalCode)) {
      return null;
    }

    final String city = text(element(geodataElement, "city"));
    final String state = text(element(geodataElement, "prov"));

    return new Location(latitude, longitude, "", city, state, postalCode, "CA");
  }

  public static Location findLocation(final double latitude, final double longitude) {
    Location result = findLocationWithGeonames(latitude, longitude);
    if (result == null) {
      result = findLocationWithGeocoder(latitude, longitude);
    }
    return result;
  }
}
