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
package org.metasyntactic.caches;

import org.metasyntactic.Application;
import org.metasyntactic.data.Location;
import org.metasyntactic.threading.ThreadingUtilities;
import static org.metasyntactic.threading.ThreadingUtilities.performOnBackgroundThread;
import org.metasyntactic.utilities.*;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.w3c.dom.Element;

import java.io.File;
import java.util.Locale;

public class UserLocationCache {
  private final Object lock = new Object();

  public UserLocationCache() {
  }

  public void downloadUserAddressLocation(final String userAddress) {
    final Runnable runnable = new Runnable() {
      public void run() {
        downloadUserAddressLocationBackgroundEntryPoint(userAddress);
      }
    };

    performOnBackgroundThread("Download User Address", runnable, this.lock, true/*visible*/);
  }

  public Location downloadUserAddressLocationBackgroundEntryPoint(final String userAddress) {
    assert ThreadingUtilities.isBackgroundThread();

    if (isNullOrEmpty(userAddress)) {
      return null;
    }

    Location location = locationForUserAddress(userAddress);

    if (location == null) {
      location = downloadAddressLocationFromWebService(massageAddress(userAddress));
      if (location != null && !location.getCountry().equals(userCountryISO())) {
        location = downloadAddressLocationFromWebService(userAddress);
      }

      saveLocation(location, userAddress);
    }

    return location;
  }

  private static boolean containsNumber(final String string) {
    for (int i = 0; i < string.length(); i++) {
      final char c = string.charAt(i);
      if (c >= '0' && c <= '9') {
        return true;
      }
    }

    return false;
  }

  private static String userCountryISO() {
    return Locale.getDefault().getCountry();
  }

  private static String massageAddress(String userAddress) {
    userAddress = userAddress.trim();
    if (userAddress.length() <= 8 && containsNumber(userAddress)) {
      // possibly a postal code.  append the country to help make it unique

      // we append the US name for the country here since that's what the
      // backend prefers
      final String country = Locale.getDefault().getDisplayCountry(Locale.US);
      if (!isNullOrEmpty(country)) {
        return userAddress + ". " + country;
      }
    }

    return null;
  }

  public Location locationForUserAddress(final String userAddress) {
    if (isNullOrEmpty(userAddress)) {
      return null;
    }

    final Location location = loadLocation(massageAddress(userAddress));
    if (location != null) {
      return location;
    }

    return loadLocation(userAddress);
  }

  private static Location processResult(final Element resultElement) {
    if (resultElement != null) {
      final String latitude = resultElement.getAttribute("latitude");
      final String longitude = resultElement.getAttribute("longitude");
      final String address = resultElement.getAttribute("address");
      final String city = resultElement.getAttribute("city");
      final String state = resultElement.getAttribute("state");
      final String country = resultElement.getAttribute("country");
      final String postalCode = resultElement.getAttribute("zipcode");

      if (!isNullOrEmpty(latitude) && !isNullOrEmpty(longitude)) {
        try {
          return new Location(Double.parseDouble(latitude), Double.parseDouble(longitude), address, city, state,
                              postalCode, country);
        } catch (final NumberFormatException e) {
          ExceptionUtilities.log(UserLocationCache.class, "processResult", e);
          return null;
        }
      }
    }

    return null;
  }

  private Location downloadAddressLocationFromWebService(final String address) {
    if (isNullOrEmpty(address)) {
      return null;
    }

    final Location result = downloadAddressLocationFromWebServiceWorker(address);
    if (result != null && result.getLatitude() != 0 && result.getLongitude() != 0) {
      if (isNullOrEmpty(result.getPostalCode())) {
        final Location resultLocation = LocationUtilities.findLocation(result.getLatitude(), result.getLongitude());
        if (!isNullOrEmpty(resultLocation.getPostalCode())) {
          return new Location(result.getLatitude(), result.getLongitude(), result.getAddress(), result.getCity(),
                              result.getState(), resultLocation.getPostalCode(), result.getCountry());
        }
      }
    }

    return result;
  }

  private Location downloadAddressLocationFromWebServiceWorker(final String address) {
    final String escapedAddress = "http://" + Application.host + ".appspot.com/LookupLocation?q=" + StringUtilities.urlEncode(
        address);

    final Element element = NetworkUtilities.downloadXml(escapedAddress, true);

    return processResult(element);
  }

  private Location loadLocation(final String address) {
    if (!isNullOrEmpty(address)) {
      return FileUtilities.readPersistable(Location.reader, locationFile(address));
    }

    return null;
  }

  private File locationFile(final String address) {
    return new File(Application.userLocationsDirectory, FileUtilities.sanitizeFileName(address));
  }

  private void saveLocation(final Location location, final String address) {
    if (location == null || isNullOrEmpty(address)) {
      return;
    }

    FileUtilities.writePersistable(location, locationFile(address));
  }

  public void reportLocationForAddress(Location location, String address) {
    saveLocation(location, address);
  }
}