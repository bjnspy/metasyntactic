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

import javax.wsdl.WSDLException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.parsers.ParserConfigurationException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.io.IOException;

public abstract class AbstractInvocationHandler implements InvocationHandler {
    private final Object[] EMPTY_ARRAY = {};
    public Object invoke(final Object o, final Method method, final Object[] objects) throws Throwable {
        return invoke(method.getName(), objects == null ? EMPTY_ARRAY : objects);
    }

    protected abstract Object invoke(String name, Object... objects) throws IOException, WSDLException, TransformerException, ParserConfigurationException;
}
