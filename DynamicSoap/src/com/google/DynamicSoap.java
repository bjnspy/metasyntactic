// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package com.google;

import static com.google.Utilities.cast;
import static com.google.Utilities.iterable;
import org.exolab.castor.xml.schema.ComplexType;
import org.exolab.castor.xml.schema.Schema;
import org.exolab.castor.xml.schema.SimpleType;
import org.exolab.castor.xml.schema.reader.SchemaReader;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.extensions.ExtensibilityElement;
import javax.wsdl.extensions.UnknownExtensibilityElement;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import javax.xml.namespace.QName;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.ws.Dispatch;
import javax.xml.ws.Service;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DynamicSoap {

    public WebServicesInvocationHandler soap(final String wsdlUri) throws IOException, WSDLException {
        return new WebServicesInvocationHandler(wsdlUri);
    }

    public static void main(final String... args) throws Throwable {
        amazon();
        weather();
    }

    private static void amazon() throws IOException, WSDLException, TransformerException, ParserConfigurationException {
        final WebServicesInvocationHandler handler = new DynamicSoap().soap("http://soap.amazon.com/schemas2/AmazonWebServices.wsdl");
        System.out.println(handler.getServices());

        final ServiceInvocationHandler serviceHandler = handler.getService("AmazonSearchService");
        System.out.println(serviceHandler.getOperations());

        serviceHandler.invoke("PowerSearchRequest");
    }

    private static void weather() throws IOException, WSDLException, TransformerException, ParserConfigurationException {
        final WebServicesInvocationHandler handler = new DynamicSoap().soap("http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl");
        System.out.println(handler.getServices());

        final ServiceInvocationHandler serviceHandler = handler.getService("ndfdXML");
        System.out.println(serviceHandler.getOperations());

        serviceHandler.invoke("LatLonListSquare", 40.760423, -73.987942, 0.1, 0.1, 0.01);
        serviceHandler.invoke("LatLonListSquare", createMap(
                "centerPointLat", 40.760423,
                "centerPointLon", -73.987942,
                "distanceLat", 0.1,
                "distanceLon", 0.1,
                "resolution", 0.01));
    }

    private static Map<Object, Object> createMap(final Object... args) {
        final Map<Object, Object> map = new HashMap<Object, Object>();
        for (int i = 0; i < args.length; i += 2) {
            map.put(args[i], args[i + 1]);
        }
        return map;
    }

    private static void test() throws IOException, ParserConfigurationException, SAXException, WSDLException, TransformerException {
        final String wsdl = "http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl";
        final Service svc = Service.create(
                new URL(wsdl),
                new QName(wsdl, "ndfdXML"));

        // Create the dynamic invocation object from this service.
        final Dispatch<Source> dispatch = svc.createDispatch(
                new QName(wsdl, "ndfdXMLPort"),
                Source.class,
                Service.Mode.PAYLOAD);

        // Build the message.
        final String content =
                "<ns2:LatLonListSquare xmlns:ns2=\"http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl\">" +
                        "<centerPointLat>40.760423</centerPointLat>" +
                        "<centerPointLon>-73.987942</centerPointLon>" +
                        "<distanceLat>0.1</distanceLat>" +
                        "<distanceLon>0.1</distanceLon>" +
                        "<resolution>0.01</resolution>" +
                        "</ns2:LatLonListSquare>";

        final WSDLReader wsdlReader = WSDLFactory.newInstance().newWSDLReader();
        final Definition definition = wsdlReader.readWSDL(wsdl);
        final List<UnknownExtensibilityElement> extensibilityElements = getSchemaElements(definition.getTypes().getExtensibilityElements());


        final SchemaReader schemaReader = new SchemaReader(new InputSource(""));
        final Schema schema = schemaReader.read();

        for (final ComplexType c : cast(iterable(schema.getComplexTypes()), ComplexType.class)) {
            System.out.println(c);
        }

        for (final SimpleType s : cast(iterable(schema.getSimpleTypes()), SimpleType.class)) {
            System.out.println(s);
        }

        // Invoke the operation.
        final Source source = dispatch.invoke(new StreamSource(new StringReader(content)));
        final StringWriter writer = new StringWriter();
        TransformerFactory.newInstance().newTransformer().transform(source, new StreamResult(writer));

        // Write out the response content.
        final String responseContent = writer.toString();
        System.out.println(responseContent);
    }

    private static List<UnknownExtensibilityElement> getSchemaElements(final List extensibilityElements) {
        final List<UnknownExtensibilityElement> result = new ArrayList<UnknownExtensibilityElement>();
        for (final ExtensibilityElement element : cast(extensibilityElements, ExtensibilityElement.class)) {
            if (element.getElementType().getLocalPart().equals("schema") &&
                    element instanceof UnknownExtensibilityElement) {
                result.add((UnknownExtensibilityElement) element);
            }
        }
        return result;
    }
}
