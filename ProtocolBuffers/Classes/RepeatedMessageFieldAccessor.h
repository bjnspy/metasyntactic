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

#if 0
#import "RepeatedFieldAccessor.h"

@interface PBRepeatedMessageFieldAccessor : PBRepeatedFieldAccessor {
  @private
    SEL createBuilderSelector;
}

+ (PBRepeatedMessageFieldAccessor*) accessorWithField:(PBFieldDescriptor*) field
                                                 name:(NSString*) name
                                         messageClass:(Class) messageClass
                                         builderClass:(Class) builderClass;

- (void) setRepeated:(PBGeneratedMessage_Builder*) builder index:(int32_t) index value:(id) value;
- (void) addRepeated:(PBGeneratedMessage_Builder*) builder value:(id) value;
- (id<PBMessage_Builder>) createBuilder;

@end
#endif