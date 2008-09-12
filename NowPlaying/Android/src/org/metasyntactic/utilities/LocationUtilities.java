package org.metasyntactic.utilities;

import static org.metasyntactic.utilities.XmlUtilities.element;
import static org.metasyntactic.utilities.XmlUtilities.text;
import org.w3c.dom.Element;

import java.net.MalformedURLException;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class LocationUtilities {
  private LocationUtilities() {

  }


  public static String reverseLookupPostalCode(double latitude, double longitude) throws MalformedURLException {
    String postalCode = reverseLookupUSPostalCode(latitude, longitude);
    if (StringUtilities.isNullOrEmpty(postalCode)) {
      postalCode = reverseLookupCAPostalCode(latitude, longitude);
    }
    return postalCode;
  }


  private static String reverseLookupCAPostalCode(double latitude, double longitude) throws MalformedURLException {
    String address = "http://geocoder.ca/?latt=" + latitude + "&longt=" + longitude + "&geoit=xml&reverse=Reverse+GeoCode+it";
    Element geodataElement = NetworkUtilities.downloadXml(address);
    Element postalElement = element(geodataElement, "postal");
    return text(postalElement);
  }


  private static String reverseLookupUSPostalCode(double latitude, double longitude) throws MalformedURLException {
    String address = "http://ws.geonames.org/findNearbyPostalCodes?lat=" + latitude + "&lng=" + longitude + "&maxRows=1";
    Element geonamesElement = NetworkUtilities.downloadXml(address);
    Element codeElement = element(geonamesElement, "code");
    Element postalElement = element(codeElement, "postalCode");
    Element countryElement = element(codeElement, "countryCode");
    String country = text(countryElement);

    if ("CA".equals(country)) {
      return null;
    }

    return text(postalElement);
  }
}
