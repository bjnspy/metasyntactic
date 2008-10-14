package org.metasyntactic.utilities;

import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.InputStream;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class XmlUtilities {
  private XmlUtilities() {

  }


  public static Element parseInputStream(InputStream in) {
    try {
      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      DocumentBuilder documentBuilder = factory.newDocumentBuilder();
      Document document = documentBuilder.parse(in);
      if (document == null) {
        return null;
      }

      return document.getDocumentElement();
    } catch (IOException e) {
      ExceptionUtilities.log(XmlUtilities.class, "parseInputStream", e);
      return null;
    } catch (SAXException e) {
      ExceptionUtilities.log(XmlUtilities.class, "parseInputStream", e);
      return null;
    } catch (ParserConfigurationException e) {
      throw new RuntimeException(e);
    }
  }


  public static Element element(Element element, String name) {
    if (element == null) {
      return null;
    }

    NodeList list = element.getChildNodes();
    for (int i = 0; i < list.getLength(); i++) {
      Node child = list.item(i);
      if (child.getNodeType() == Node.ELEMENT_NODE) {
        Element childElement = (Element)child;
        if (childElement.getTagName().equals(name)) {
          return childElement;
        }
      }
    }

    return null;
  }


  public static String text(Element element) {
    if (element == null) {
      return null;
    }

    if (!element.hasChildNodes()) {
      return null;
    }

    Node child = element.getFirstChild();
    if (child.getNodeType() != Node.TEXT_NODE) {
      return null;
    }

    Text textNode = (Text)child;
    return textNode.getData();
  }
}