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

/**
 * Abstract base interface for protocol-buffer-based RPC services.  Services
 * themselves are abstract classes (implemented either by servers or as
 * stubs), but they subclass this base interface.  The methods of this
 * interface can be used to call the methods of the service without knowing
 * its exact type at compile time (analogous to the Message interface).
 *
 * @author Cyrus Najmabadi
 */
@protocol PBService
/**
 * Get the {@code ServiceDescriptor} describing this service and its methods.
 */
- (PBServiceDescriptor*) descriptor;

/**
 * <p>Call a method of the service specified by MethodDescriptor.  This is
 * normally implemented as a simple {@code switch()} that calls the standard
 * definitions of the service's methods.
 *
 * <p>Preconditions:
 * <ul>
 *   <li>{@code method.getService() == getDescriptorForType()}
 *   <li>{@code request} is of the exact same class as the object returned by
 *       {@code getRequestPrototype(method)}.
 *   <li>{@code controller} is of the correct type for the RPC implementation
 *       being used by this Service.  For stubs, the "correct type" depends
 *       on the RpcChannel which the stub is using.  Server-side Service
 *       implementations are expected to accept whatever type of
 *       {@code RpcController} the server-side RPC implementation uses.
 * </ul>
 *
 * <p>Postconditions:
 * <ul>
 *   <li>{@code done} will be called when the method is complete.  This may be
 *       before {@code callMethod()} returns or it may be at some point in
 *       the future.
 *   <li>The parameter to {@code done} is the response.  It must be of the
 *       exact same type as would be returned by
 *       {@code getResponsePrototype(method)}.
 *   <li>If the RPC failed, the parameter to {@code done} will be
 *       {@code nil}.  Further details about the failure can be found by
 *       querying {@code controller}.
 * </ul>
 */
- (void) callMethod:(PBMethodDescriptor*) method
         controller:(id<PBRpcController>) controller
            request:(id<PBMessage>) request
             target:(id) target
           selector:(SEL) selector;

/**
 * <p>{@code callMethod()} requires that the request passed in is of a
 * particular subclass of {@code Message}.  {@code getRequestPrototype()}
 * gets the default instances of this type for a given method.  You can then
 * call {@code Message.newBuilderForType()} on this instance to
 * construct a builder to build an object which you can then pass to
 * {@code callMethod()}.
 *
 * <p>Example:
 * <pre>
 *   MethodDescriptor method =
 *     service.getDescriptorForType().findMethodByName("Foo");
 *   Message request =
 *     stub.getRequestPrototype(method).newBuilderForType()
 *         .mergeFrom(input).build();
 *   service.callMethod(method, request, callback);
 * </pre>
 */
- (id<PBMessage>) getRequestPrototype:(PBMethodDescriptor*) method;

/**
 * Like {@code getRequestPrototype()}, but gets a prototype of the response
 * message.  {@code getResponsePrototype()} is generally not needed because
 * the {@code Service} implementation constructs the response message itself,
 * but it may be useful in some cases to know ahead of time what type of
 * object will be returned.
 */
- (id<PBMessage>) getResponsePrototype:(PBMethodDescriptor*) method;
@end