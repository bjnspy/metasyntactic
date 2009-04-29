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
import org.apache.axis2.description.AxisOperation;
import org.apache.axis2.AxisFault;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.axis2.client.ServiceClient;
import org.apache.axiom.om.OMElement;

import java.lang.reflect.InvocationHandler;
import java.util.*;

import com.sun.org.apache.xml.internal.utils.StringToIntTable;
import com.sun.xml.internal.ws.api.server.Invoker;
import static com.google.Utilities.cast;
import static com.google.Utilities.createIterable;

import javax.wsdl.Operation;
import javax.xml.namespace.QName;

public class AxisServiceInvocationHandler extends AbstractInvocationHandler {
    private final WebServiceDefinitionInvocationHandler webServiceDefinitionInvocationHandler;
    private final AxisService axisService;
    private SortedMap<String,OperationInvocationHandler> operationsMap;

    public AxisServiceInvocationHandler(final WebServiceDefinitionInvocationHandler webServiceDefinitionInvocationHandler,
                                        final AxisService axisService) {
        this.webServiceDefinitionInvocationHandler = webServiceDefinitionInvocationHandler;
        this.axisService = axisService;
    }

    public String getName() {
        return axisService.getName();
    }

    public Set<String> listOperations() {
        return populateOperationsMap().keySet();
    }

    private SortedMap<String, OperationInvocationHandler> populateOperationsMap() {
        if (operationsMap == null) {
            final SortedMap<String, OperationInvocationHandler> map = new TreeMap<String, OperationInvocationHandler>();

            for (final AxisOperation operation : createIterable(cast(axisService.getOperations(), AxisOperation.class))) {
                map.put(operation.getName().getLocalPart(), new OperationInvocationHandler(this, operation));
            }
            operationsMap = Collections.unmodifiableSortedMap(map);
        }

        return operationsMap;
    }

    public OperationInvocationHandler getOperation(String name) {
        return populateOperationsMap().get(name);
    }


    @Override
    protected Object invoke(final String name, final Object[] objects) throws AxisFault {
        OperationInvocationHandler operation = populateOperationsMap().get(name);
        if (operation == null) {
            return null;
        }

        return null;
        //operation.
        //RPCServiceClient client = new RPCServiceClient(null, axisService);
        //client.invokeBlocking()
    }


}
*/