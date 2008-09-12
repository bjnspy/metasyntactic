package org.metasyntactic.caches;

import org.metasyntactic.data.Location;
import org.metasyntactic.io.IOUtilities;
import org.metasyntactic.utilities.LocationUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.w3c.dom.Element;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.util.prefs.BackingStoreException;
import java.util.prefs.Preferences;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class AddressLocationCache {
  private final Object lock = new Object();
  private final Preferences preferences = Preferences.userNodeForPackage(AddressLocationCache.class);


  public void update() {
    Thread thread = new Thread(
        new Runnable() {
          public void run() {
            try {
              AddressLocationCache.this.updateBackgroundEntryPoint();
            } catch (IOException e) {
              throw new RuntimeException(e);
            } catch (ClassNotFoundException e) {
              throw new RuntimeException(e);
            } catch (BackingStoreException e) {
              throw new RuntimeException(e);
            }
          }
        });

    thread.setPriority(Thread.MIN_PRIORITY);
    thread.start();
  }


  private void updateBackgroundEntryPoint() throws IOException, ClassNotFoundException, BackingStoreException {
    synchronized (lock) {
      for (String key : preferences.keys()) {
        lookupAddressLocation(key);
      }
    }
  }


  private Location lookupAddressLocation(String address) throws IOException, ClassNotFoundException {
    byte[] bytes = preferences.getByteArray(address, null);

    if (bytes == null) {
      Location location = lookupAddressLocationFromWebService(address);
      bytes = IOUtilities.writeObject(location);
      preferences.putByteArray(address, bytes);
    }

    return (Location) IOUtilities.readObject(bytes);
  }


  private Location lookupAddressLocationFromWebService(
      String address) throws UnsupportedEncodingException, MalformedURLException {
    if (StringUtilities.isNullOrEmpty(address)) {
      return null;
    }

    String encodedAddress = URLEncoder.encode(address, "UTF-8");
    String url = "http://metaboxoffice2.appspot.com/LookupLocation?q=" + encodedAddress;
    Element element = NetworkUtilities.downloadXml(url);
    if (element == null) {
      return null;
    }

    Location location = processElement(element);
    if (location != null && StringUtilities.isNullOrEmpty(location.getPostalCode())) {
      if (location.getLatitude() != 0 && location.getLongitude() != 0) {
        String postalCode = LocationUtilities.reverseLookupPostalCode(location.getLatitude(), location.getLongitude());

        if (!StringUtilities.isNullOrEmpty(postalCode)) {
          location = new Location(location.getLatitude(), location.getLongitude(), location.getAddress(),
              location.getCity(), location.getState(), postalCode, location.getCountry());
        }
      }
    }
    return location;
  }


  private Location processElement(Element element) {
    String latitude = element.getAttribute("latitude");
    String longitude = element.getAttribute("longitude");
    String address = element.getAttribute("address");
    String city = element.getAttribute("city");
    String state = element.getAttribute("state");
    String country = element.getAttribute("country");
    String postalCode = element.getAttribute("zipcode");

    if (StringUtilities.isNullOrEmpty(latitude) || StringUtilities.isNullOrEmpty(longitude)) {
      return null;
    }

    return new Location(Double.parseDouble(latitude), Double.parseDouble(longitude), address, city, state, postalCode,
        country);
  }
}
