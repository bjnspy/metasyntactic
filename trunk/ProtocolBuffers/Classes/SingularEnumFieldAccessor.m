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

#import "SingularEnumFieldAccessor.h"

@interface PBSingularEnumFieldAccessor()
    @property SEL valueOfMethod;
    @property SEL valueDescriptorMethod;
@end


@implementation PBSingularEnumFieldAccessor

@synthesize valueOfMethod;
@synthesize valueDescriptorMethod;

- (void) dealloc {
    self.valueOfMethod = 0;
    self.valueDescriptorMethod = 0;
    [super dealloc];
}


- (id) initWithField:(PBFieldDescriptor*) field
                name:(NSString*) name
        messageClass:(Class) messageClass
        builderClass:(Class) builderClass {
    if (self = [super initWithField:field name:name messageClass:messageClass builderClass:builderClass]) {
        self.valueOfMethod = @selector(valueOfDescriptor:);
        self.valueDescriptorMethod = @selector(valueDescriptor);
    }
    
    return self;
}


+ (PBSingularEnumFieldAccessor*) accessorWithField:(PBFieldDescriptor*) field
                                                             name:(NSString*) name
                                                     messageClass:(Class) messageClass
                                                     builderClass:(Class) builderClass {
    return [[[PBSingularEnumFieldAccessor alloc] initWithField:field
                                                          name:name
                                                  messageClass:messageClass
                                                  builderClass:builderClass] autorelease];
}


- (id) get:(PBGeneratedMessage*) message {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (void) set:(PBGeneratedMessage_Builder*) builder value:(id) value {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}

@end