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

import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
        Element childElement = (Element) child;
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

    Text textNode = (Text) child;
    return textNode.getData();
  }

  public static List<Element> children(Element element) {
    if (element != null) {
      NodeList list = element.getChildNodes();
      if (list != null) {
        List<Element> result = new ArrayList<Element>();

        for (int i = 0; i < list.getLength(); i++) {
          Node child = list.item(i);
          if (child instanceof Element) {
            result.add((Element) child);
          }
        }

        return result;
      }
    }

    return Collections.emptyList();
  }
}