package org.metasyntactic.utilities;

import org.w3c.dom.Element;

import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NetworkUtilities {
  private NetworkUtilities() {

  }


  public static Element downloadXml(String url) throws MalformedURLException {
    return downloadXml(new URL(url));
  }


  private static Element downloadXml(URL url) {

    try {
      return XmlUtilities.parseInputStream(url.openStream());
    } catch (ParserConfigurationException e) {
      throw new RuntimeException(e);
    } catch (IOException e) {
      ExceptionUtilities.log(NetworkUtilities.class, "downloadXml", e);
      return null;
    }
  }
}
