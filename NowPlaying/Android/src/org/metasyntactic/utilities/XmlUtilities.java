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

  public static Element parseInputStream(final InputStream in) {
    try {
      final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      final DocumentBuilder documentBuilder = factory.newDocumentBuilder();
      final Document document = documentBuilder.parse(in);
      if (document == null) {
        return null;
      }

      return document.getDocumentElement();
    } catch (final IOException e) {
      ExceptionUtilities.log(XmlUtilities.class, "parseInputStream", e);
      return null;
    } catch (final SAXException e) {
      ExceptionUtilities.log(XmlUtilities.class, "parseInputStream", e);
      return null;
    } catch (final ParserConfigurationException e) {
      throw new RuntimeException(e);
    }
  }

  public static Element element(final Element element, final String name) {
    if (element == null) {
      return null;
    }

    final NodeList list = element.getChildNodes();
    for (int i = 0; i < list.getLength(); i++) {
      final Node child = list.item(i);
      if (child.getNodeType() == Node.ELEMENT_NODE) {
        final Element childElement = (Element) child;
        if (childElement.getTagName().equals(name)) {
          return childElement;
        }
      }
    }

    return null;
  }

  public static String text(final Element element) {
    if (element == null) {
      return null;
    }

    if (!element.hasChildNodes()) {
      return null;
    }

    final Node child = element.getFirstChild();
    if (child.getNodeType() != Node.TEXT_NODE) {
      return null;
    }

    final Text textNode = (Text) child;
    return textNode.getData();
  }

  public static List<Element> children(final Element element) {
    if (element != null) {
      final NodeList list = element.getChildNodes();
      if (list != null) {
        final List<Element> result = new ArrayList<Element>();

        for (int i = 0; i < list.getLength(); i++) {
          final Node child = list.item(i);
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