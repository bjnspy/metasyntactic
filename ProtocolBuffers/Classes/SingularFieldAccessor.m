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

#import "SingularFieldAccessor.h"

#import "FieldDescriptor.h"
#import "ObjectiveCType.h"

@interface PBSingularFieldAccessor()
    @property (retain) PBFieldDescriptor* field;
    @property SEL getSelector;
    @property SEL setSelector;
    @property SEL hasSelector;
    @property SEL clearSelector;
@end


@implementation PBSingularFieldAccessor

@synthesize field;
@synthesize getSelector;
@synthesize setSelector;
@synthesize hasSelector;
@synthesize clearSelector;

- (void) dealloc {
    self.field = nil;
    self.getSelector = 0;
    self.setSelector = 0;
    self.hasSelector = 0;
    self.clearSelector = 0;

    [super dealloc];
}


- (id) initWithField:(PBFieldDescriptor*) field_
                name:(NSString*) name
        messageClass:(Class) messageClass
        builderClass:(Class) builderClass {
    if (self = [super initWithField:field_]) {
        NSString* camelName = [self camelName:name];
        self.getSelector = NSSelectorFromString(camelName);
        self.setSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", name]);
        self.hasSelector = NSSelectorFromString([NSString stringWithFormat:@"has%@", name]);
        self.clearSelector = NSSelectorFromString([NSString stringWithFormat:@"clear%@", name]);
    }

    return self;
}


+ (PBSingularFieldAccessor*) accessorWithField:(PBFieldDescriptor*) field
                                          name:(NSString*) name
                                  messageClass:(Class) messageClass
                                  builderClass:(Class) builderClass {
    return [[[PBSingularFieldAccessor alloc] initWithField:field name:name messageClass:messageClass builderClass:builderClass] autorelease];
}


- (id) get:(PBGeneratedMessage*) message {
    IMP imp = [message methodForSelector:getSelector];

    switch (PBObjectiveCTypeFromFieldDescriptorType(self.field.type)) {
        default: {
            return imp(message, getSelector);
        }
        case PBObjectiveCTypeInt32: {
            int32_t v = ((int32_t (*) (id,SEL))imp)(message, getSelector);
            return [NSNumber numberWithInt:v];
        }
        case PBObjectiveCTypeInt64: {
            int64_t v = ((int64_t (*) (id,SEL))imp)(message, getSelector);
            return [NSNumber numberWithLongLong:v];
        }
        case PBObjectiveCTypeFloat32: {
            Float32 v = ((Float32 (*) (id,SEL))imp)(message, getSelector);
            return [NSNumber numberWithFloat:v];
        }
        case PBObjectiveCTypeFloat64: {
            Float64 v = ((Float64 (*) (id,SEL))imp)(message, getSelector);
            return [NSNumber numberWithDouble:v];
        }
        case PBObjectiveCTypeBool: {
            BOOL v = ((BOOL (*) (id,SEL))imp)(message, getSelector);
            return [NSNumber numberWithBool:v];
        }
    }
}


- (void) set:(PBGeneratedMessage_Builder*) builder value:(id) value {
    IMP imp = [builder methodForSelector:setSelector];

    switch (PBObjectiveCTypeFromFieldDescriptorType(self.field.type)) {
        default: {
            imp(builder, setSelector, value);
            return;
        }
        case PBObjectiveCTypeInt32: {
            imp(builder, setSelector, [value intValue]);
            return;
        }
        case PBObjectiveCTypeInt64: {
            imp(builder, setSelector, [value longLongValue]);
            return;
        }
        case PBObjectiveCTypeFloat32: {
            imp(builder, setSelector, [value floatValue]);
            return;
        }
        case PBObjectiveCTypeFloat64: {
            imp(builder, setSelector, [value doubleValue]);
            return;
        }
        case PBObjectiveCTypeBool: {
            imp(builder, setSelector, [value boolValue]);
            return;
        }
    }
}


- (void) setRepeated:(PBGeneratedMessage_Builder*) builder index:(int32_t) index value:(id) value {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (void) addRepeated:(PBGeneratedMessage_Builder*) builder value:(id) value {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (BOOL) has:(PBGeneratedMessage*) message {
    IMP imp = [message methodForSelector:hasSelector];
    BOOL result = ((BOOL (*) (id,SEL))imp)(message, hasSelector);
    return result;
}


- (NSArray*) getRepeated:(PBGeneratedMessage*) message {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (void) clear:(PBGeneratedMessage_Builder*) builder {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) createBuilder {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}

@end