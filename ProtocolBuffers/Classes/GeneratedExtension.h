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

@interface PBGeneratedExtension : NSObject {
@private
    PBFieldDescriptor* descriptor;
    Class type;
    SEL enumValueOf;
    SEL enumGetValueDescriptor;
    id<PBMessage> messageDefaultInstance;
}

@property (readonly, retain) PBFieldDescriptor* descriptor;
@property (readonly, retain) id<PBMessage> messageDefaultInstance;

+ (PBGeneratedExtension*) extensionWithDescriptor:(PBFieldDescriptor*) descriptor
                                             type:(Class) type;

- (id) toReflectionType:(id) value;
- (id) singularToReflectionType:(id) value;
- (id) fromReflectionType:(id) value;
- (id) singularFromReflectionType:(id) value;

@end