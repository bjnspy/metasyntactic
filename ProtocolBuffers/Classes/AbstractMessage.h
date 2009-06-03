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

#import "Message.h"

#if 0
/**
 * A partial implementation of the {@link Message} interface which implements
 * as many methods of that interface as possible in terms of other methods.
 *
 * @author Cyrus Najmabadi
 */
@interface PBAbstractMessage : NSObject<PBMessage> {
  @private
    int32_t am_memoizedSize;
}

- (PBDescriptor*) descriptor;
- (id<PBMessage>) defaultInstance;
- (NSDictionary*) allFields;

- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;
- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field;

- (PBUnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;
- (int32_t) serializedSize;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (void) writeToOutputStream:(NSOutputStream*) output;
- (NSData*) data;

- (id<PBMessage_Builder>) builder;

@end
#else
/**
 * A partial implementation of the {@link Message} interface which implements
 * as many methods of that interface as possible in terms of other methods.
 *
 * @author Cyrus Najmabadi
 */
@interface PBAbstractMessage : NSObject<PBMessage> {
@private
  //int32_t am_memoizedSize;
}
/*
- (NSData*) data;

- (BOOL) isInitialized;
- (int32_t) serializedSize;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;

- (id<PBMessage>) defaultInstance;
- (PBUnknownFieldSet*) unknownFields;

- (id<PBMessage_Builder>) builder;
 */

@end
#endif