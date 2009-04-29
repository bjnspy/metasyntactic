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

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.Service;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import javax.xml.namespace.QName;
import java.io.IOException;
import java.util.*;

public class WebServicesInvocationHandler extends AbstractInvocationHandler {
    private final String wsdlUri;
    private Definition definition;
    private SortedMap<String, ServiceInvocationHandler> serviceMap;


    public WebServicesInvocationHandler(final String wsdlUri) {
        this.wsdlUri = wsdlUri;
    }


    public Definition getDefinition() throws WSDLException {
        if (definition == null) {
            final WSDLReader reader = WSDLFactory.newInstance().newWSDLReader();
            definition = reader.readWSDL(wsdlUri);
        }

        return definition;
    }

    public Set<String> getServices() throws IOException, WSDLException {
        return getServiceMap().keySet();
    }

    private SortedMap<String, ServiceInvocationHandler> getServiceMap() throws IOException, WSDLException {
        if (serviceMap == null) {
            final SortedMap<String, ServiceInvocationHandler> result = new TreeMap<String, ServiceInvocationHandler>();
            for (final Map.Entry<QName, Service> entry : cast(getDefinition().getServices().entrySet(), Map.Entry.class)) {
                result.put(entry.getKey().getLocalPart(), new ServiceInvocationHandler(this, entry.getValue()));
            }

            serviceMap = Collections.unmodifiableSortedMap(result);
        }

        return serviceMap;
    }

    public ServiceInvocationHandler getService(final String name) throws IOException, WSDLException {
        return getServiceMap().get(name);
    }

    @Override
    public Object invoke(final String name, final Object[] objects) throws IOException, WSDLException {
        if (name.startsWith("get") && name.endsWith("Service")) {
            final String serviceName = name.substring("get".length(), name.length() - "Service".length());
            return getService(serviceName);
        }

        return null;
    }

    public String getWsdlUri() {
        return wsdlUri;
    }
}
