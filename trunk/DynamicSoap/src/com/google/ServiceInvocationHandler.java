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
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import javax.wsdl.*;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.ws.Dispatch;
import java.io.IOException;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.*;

public class ServiceInvocationHandler extends AbstractInvocationHandler {
    private final WebServicesInvocationHandler webServicesInvocationHandler;
    private final javax.wsdl.Service wsdlService;
    private javax.xml.ws.Service wsService;

    private SortedMap<String, BindingOperation> bindingOperationNameMap;
    private Map<BindingOperation, Port> bindingOperationPortMap;

    public ServiceInvocationHandler(final WebServicesInvocationHandler webServicesInvocationHandler,
                                    final javax.wsdl.Service wsdlService) {
        this.webServicesInvocationHandler = webServicesInvocationHandler;
        this.wsdlService = wsdlService;
    }

    private SortedMap<String, BindingOperation> getBindingOperationNameMap() {
        populateBindingOperationMaps();
        return bindingOperationNameMap;
    }

    private Map<BindingOperation, Port> getBindingOperationPortMap() {
        populateBindingOperationMaps();
        return bindingOperationPortMap;
    }

    public Set<String> getOperations() throws WSDLException {
        return getBindingOperationNameMap().keySet();
    }

    private void populateBindingOperationMaps() {
        if (bindingOperationPortMap == null) {
            final SortedMap<String, BindingOperation> nameMap = new TreeMap<String, BindingOperation>();
            final Map<BindingOperation, Port> portMap = new HashMap<BindingOperation, Port>();

            for (final Port port : cast(wsdlService.getPorts().values(), Port.class)) {
                for (final BindingOperation bindingOp : cast(port.getBinding().getBindingOperations(), BindingOperation.class)) {
                    nameMap.put(bindingOp.getName(), bindingOp);
                    portMap.put(bindingOp, port);
                }
            }

            bindingOperationNameMap = Collections.unmodifiableSortedMap(nameMap);
            bindingOperationPortMap = Collections.unmodifiableMap(portMap);
        }
    }

    @Override
    protected Object invoke(final String name, final Object... objects) throws IOException, WSDLException, TransformerException, ParserConfigurationException {
        final BindingOperation bindingOp = getBindingOperationNameMap().get(name);
        final Port port = getBindingOperationPortMap().get(bindingOp);

        if (bindingOp == null || port == null) {
            return null;
        }

        final String uri = webServicesInvocationHandler.getWsdlUri();
        final QName portQName = new QName(uri, port.getName());

        final Dispatch<Source> dispatch = getService().createDispatch(portQName, Source.class, javax.xml.ws.Service.Mode.PAYLOAD);

        final Element element = convertArguments(objects, bindingOp);
        final Source source = dispatch.invoke(new DOMSource(element));

        final StringWriter writer = new StringWriter();
        TransformerFactory.newInstance().newTransformer().transform(source, new StreamResult(writer));

        // Write out the response content.
        final String responseContent = writer.toString();
        System.out.println(responseContent);

        return responseContent;
    }

    private static Element convertArguments(final Object[] objects, final BindingOperation bindingOp) throws ParserConfigurationException, TransformerException {
        if (objects.length == 1 && Map.class.isInstance(objects[0])) {
            return convertMapArgument((Map) objects[0], bindingOp);
        } else {
            return convertArrayArgument(objects, bindingOp);
        }
    }

    private static Element convertMapArgument(final Map map, final BindingOperation bindingOp) throws ParserConfigurationException {
        final Message message = bindingOp.getOperation().getInput().getMessage();
        final List<Part> parts = message.getOrderedParts(null);
        if (parts.size() != map.size()) {
            throw new RuntimeException("Not enough arguments provided");
        }

        final Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        final Element root = document.createElement(bindingOp.getOperation().getName());
        document.appendChild(root);

        for (final Part part : parts) {
            final Object value = map.get(part.getName());
            if (value != null) {
                final Element child = document.createElement(part.getName());
                root.appendChild(child);

                final String text = convertObjectToType(value, part.getTypeName());

                final Text textNode = document.createTextNode(text);
                child.appendChild(textNode);
            }
        }

        return root;
    }

    private static Element convertArrayArgument(final Object[] objects, final BindingOperation bindingOp) throws ParserConfigurationException, TransformerException {
        final Message message = bindingOp.getOperation().getInput().getMessage();

        final List<Part> parts = message.getOrderedParts(null);
        if (parts.size() != objects.length) {
            throw new RuntimeException("Not enough arguments provided");
        }

        final Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        final Element root = document.createElement(bindingOp.getOperation().getName());
        document.appendChild(root);

        for (int i = 0; i < parts.size(); i++) {
            final Part part = parts.get(i);
            final Object value = objects[i];

            if (value != null) {
                final Element child = document.createElement(part.getName());
                root.appendChild(child);

                final String text = convertObjectToType(value, part.getTypeName());

                final Text textNode = document.createTextNode(text);
                child.appendChild(textNode);
            }
        }

        return root;
    }

    private static String convertObjectToType(final Object value, final QName typeName) {
        return String.valueOf(value);
    }

    private javax.xml.ws.Service getService() throws MalformedURLException {
        if (wsService == null) {
            final String uri = webServicesInvocationHandler.getWsdlUri();
            wsService = javax.xml.ws.Service.create(new URL(uri), wsdlService.getQName());
        }

        return wsService;
    }

    public WebServicesInvocationHandler getWebServicesInvocationHandler() {
        return webServicesInvocationHandler;
    }
}
