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
import org.apache.axis2.description.AxisOperation;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.axis2.AxisFault;

import java.io.IOException;

public class OperationInvocationHandler extends AbstractInvocationHandler {
    private final AxisOperation axisOperation;
    private final AxisServiceInvocationHandler axisServiceInvocationHandler;

    public OperationInvocationHandler(final AxisServiceInvocationHandler axisServiceInvocationHandler,
                                      final AxisOperation axisOperation) {
        this.axisServiceInvocationHandler = axisServiceInvocationHandler;
        this.axisOperation = axisOperation;
    }

    @Override
    protected Object invoke(final String name, final Object[] objects) throws IOException {
        return invoke(objects);
    }

    public Object invoke(final Object... objects) throws AxisFault {
        RPCServiceClient client = new RPCServiceClient(null, axisOperation.getAxisService());
        return client.invokeBlocking(axisOperation.getName(), objects);
    }
}
*/