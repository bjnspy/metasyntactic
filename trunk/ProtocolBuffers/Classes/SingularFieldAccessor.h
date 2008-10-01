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

#import "FieldAccessor.h"

@interface SingularFieldAccessor : NSObject<GeneratedMessage_FieldAccessor> {

}

+ (SingularFieldAccessor*) accessorWithField:(FieldDescriptor*) field
                                                             name:(NSString*) name
                                                     messageClass:(Class) messageClass
                                                     builderClass:(Class) builderClass;

- (id) get:(GeneratedMessage*) message;
- (void) set:(GeneratedMessage_Builder*) builder value:(id) value;
- (id) getRepeated:(GeneratedMessage*) message index:(int32_t) index;
- (void) setRepeated:(GeneratedMessage_Builder*) builder index:(int32_t) index value:(id) value;
- (void) addRepeated:(GeneratedMessage_Builder*) builder value:(id) value;
- (BOOL) has:(GeneratedMessage*) message;
- (int32_t) getRepeatedCount:(GeneratedMessage*) message;
- (void) clear:(GeneratedMessage_Builder*) builder;
- (id<Message_Builder>) newBuilder;

@end
