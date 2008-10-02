// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GeneratedExtension.h"


@interface PBGeneratedExtension ()
@property (retain) PBFieldDescriptor* descriptor;
@property (retain) Class type;
@end


@implementation PBGeneratedExtension

@synthesize descriptor;
@synthesize type;

- (void) dealloc {
    self.descriptor = nil;
    self.type = nil;
    
    [super dealloc];
}


- (PBFieldDescriptor*) getDescriptor {
    return descriptor;
}

#if 0
public static final class PBGeneratedExtension<
ContainingType extends PBMessage, Type> {
    // TODO(kenton):  Find ways to avoid using Java reflection within this
    //   class.  Also try to avoid suppressing unchecked warnings.
    
    private PBGeneratedExtension(PBFieldDescriptor descriptor, Class type) {
        if (!descriptor.isExtension()) {
            throw new IllegalArgumentException(
                                               "PBGeneratedExtension given a regular (non-extension) field.");
        }
        
        this.descriptor = descriptor;
        this.type = type;
        
        switch (descriptor.getJavaType()) {
            case MESSAGE:
                enumValueOf = null;
                enumGetValueDescriptor = null;
                messageDefaultInstance =
                (PBMessage)invokeOrDie(getMethodOrDie(type, "defaultInstance"),
                                     null);
                break;
            case ENUM:
                enumValueOf = getMethodOrDie(type, "valueOf",
                                             PBEnumValueDescriptor.class);
                enumGetValueDescriptor = getMethodOrDie(type, "getValueDescriptor");
                messageDefaultInstance = null;
                break;
            default:
                enumValueOf = null;
                enumGetValueDescriptor = null;
                messageDefaultInstance = null;
                break;
        }
    }
    
    
    
    /**
     * If the extension is an embedded message or group, returns the default
     * instance of the message.
     */
    @SuppressWarnings("unchecked")
    public PBMessage getMessageDefaultInstance() {
        return messageDefaultInstance;
    }
    
    /**
     * Convert from the type used by the reflection accessors to the type used
     * by native accessors.  E.g., for enums, the reflection accessors use
     * EnumValueDescriptors but the native accessors use the generated enum
     * type.
     */
    @SuppressWarnings("unchecked")
    private Object fromReflectionType(Object value) {
        if (descriptor.isRepeated()) {
            if (descriptor.getJavaType() == FieldDescriptor.JavaType.MESSAGE ||
                descriptor.getJavaType() == FieldDescriptor.JavaType.ENUM) {
                // Must convert the whole list.
                List result = new ArrayList();
                for (Object element : (List)value) {
                    result.add(singularFromReflectionType(element));
                }
                return result;
            } else {
                return value;
            }
        } else {
            return singularFromReflectionType(value);
        }
    }
    
    /**
     * Like {@link #fromReflectionType(Object)}, but if the type is a repeated
     * type, this converts a single element.
     */
    private Object singularFromReflectionType(Object value) {
        switch (descriptor.getJavaType()) {
            case MESSAGE:
                if (type.isInstance(value)) {
                    return value;
                } else {
                    // It seems the copy of the embedded message stored inside the
                    // extended message is not of the exact type the user was
                    // expecting.  This can happen if a user defines a
                    // PBGeneratedExtension manually and gives it a different type.
                    // This should not happen in normal use.  But, to be nice, we'll
                    // copy the message to whatever type the caller was expecting.
                    return messageDefaultInstance.newBuilderForType()
                    .mergeFrom((PBMessage)value).build();
                }
            case ENUM:
                return invokeOrDie(enumValueOf, null, (PBEnumValueDescriptor)value);
            default:
                return value;
        }
    }
    
    /**
     * Convert from the type used by the native accessors to the type used
     * by reflection accessors.  E.g., for enums, the reflection accessors use
     * EnumValueDescriptors but the native accessors use the generated enum
     * type.
     */
    @SuppressWarnings("unchecked")
    private Object toReflectionType(Object value) {
        if (descriptor.isRepeated()) {
            if (descriptor.getJavaType() == FieldDescriptor.JavaType.ENUM) {
                // Must convert the whole list.
                List result = new ArrayList();
                for (Object element : (List)value) {
                    result.add(singularToReflectionType(element));
                }
                return result;
            } else {
                return value;
            }
        } else {
            return singularToReflectionType(value);
        }
    }
    
    /**
     * Like {@link #toReflectionType(Object)}, but if the type is a repeated
     * type, this converts a single element.
     */
    private Object singularToReflectionType(Object value) {
        switch (descriptor.getJavaType()) {
            case ENUM:
                return invokeOrDie(enumGetValueDescriptor, value);
            default:
                return value;
        }
    }
}
#endif

@end
