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
/**
 * Users should ignore this class.  This class provides the implementation
 * with access to the fields of a message object using Java reflection.
 */
@interface PBFieldAccessorTable : NSObject {
  @private
    PBDescriptor* descriptor;
    NSArray* fields;
}

@property (readonly, retain) PBDescriptor* descriptor;
@property (readonly, retain) NSArray* fields;

+ (PBFieldAccessorTable*) tableWithDescriptor:(PBDescriptor*) descriptor
                                   fieldNames:(NSArray*) fieldNames
                                 messageClass:(Class) messageClass
                                 builderClass:(Class) builderClass;

- (id<PBFieldAccessor>) getField:(PBFieldDescriptor*) field;

@end
#endif