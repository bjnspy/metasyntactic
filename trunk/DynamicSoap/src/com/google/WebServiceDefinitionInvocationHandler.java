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
/*
import org.apache.axis2.description.AxisService;
import org.apache.axis2.description.WSDL11ToAllAxisServicesBuilder;

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import java.io.IOException;
import java.net.URL;
import java.util.*;

import static com.google.Utilities.cast;

public class WebServiceDefinitionInvocationHandler extends AbstractInvocationHandler {
    private final String wsdlUri;
    private Definition definition;
    private WSDL11ToAllAxisServicesBuilder builder;
    private SortedMap<String, AxisServiceInvocationHandler> serviceMap;

    public WebServiceDefinitionInvocationHandler(final String wsdlUri) {
        this.wsdlUri = wsdlUri;
    }

    private Definition getDefinition() throws WSDLException {
        if (definition == null) {
            final WSDLReader reader = WSDLFactory.newInstance().newWSDLReader();
            definition = reader.readWSDL(wsdlUri);
        }

        return definition;
    }

    private WSDL11ToAllAxisServicesBuilder getBuilder() throws IOException {
        if (builder == null) {
            builder = new WSDL11ToAllAxisServicesBuilder(new URL(wsdlUri).openStream());
        }
        return builder;
    }

    public Collection<AxisServiceInvocationHandler> getServices() throws IOException {
        return getServiceMap().values();
    }

    private SortedMap<String, AxisServiceInvocationHandler> getServiceMap() throws IOException {
        if (serviceMap == null) {
            final SortedMap<String, AxisServiceInvocationHandler> result = new TreeMap<String, AxisServiceInvocationHandler>();
            final Iterable<AxisService> services = cast(getBuilder().populateAllServices(), AxisService.class);

            for (final AxisService service : services) {
                result.put(service.getName(), new AxisServiceInvocationHandler(this, service));
            }

            serviceMap = Collections.unmodifiableSortedMap(result);
        }

        return serviceMap;
    }

    public AxisServiceInvocationHandler getService(final String name) throws IOException {
        return getServiceMap().get(name);
    }

    @Override
    public Object invoke(final String name, final Object[] objects) throws IOException {
        if (name.startsWith("get") && name.endsWith("Service")) {
            final String serviceName = name.substring("get".length(), name.length() - "Service".length());
            return getService(serviceName);
        }

        return null;
    }
}
*/