package org.metasyntactic.utilities;

import org.metasyntactic.threading.PriorityMutex;
import org.w3c.dom.Element;

import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NetworkUtilities {
  private static PriorityMutex mutex;


  private NetworkUtilities() {

  }


  public static Element downloadXml(String url, boolean important) {
    try {
      return downloadXml(new URL(url), important);
    } catch (MalformedURLException e) {
      throw new RuntimeException(e);
    }
  }


  private static Element downloadXml(URL url, boolean important) {
    try {
      mutex.lock(important);
      return downloadXmlWorker(url);
    } finally {
      mutex.unlock(important);
    }
  }


  private static Element downloadXmlWorker(URL url) {
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
