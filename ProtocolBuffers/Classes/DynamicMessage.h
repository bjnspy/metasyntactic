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

#import "AbstractMessage.h"

/**
 * An implementation of {@link Message} that can represent arbitrary types,
 * given a {@link Descriptors.Descriptor}.
 *
 * @author Cyrus Najmabadi
 */
@interface PBDynamicMessage : PBAbstractMessage {
  @private
    PBDescriptor* type;
    PBFieldSet* fields;
    PBUnknownFieldSet* unknownFields;
    int32_t dm_memoizedSize;
}

@property (readonly, retain) PBDescriptor* type;
@property (readonly, retain) PBFieldSet* fields;
@property (readonly, retain) PBUnknownFieldSet* unknownFields;

+ (PBDynamicMessage*) messageWithType:(PBDescriptor*) type fields:(PBFieldSet*) fields unknownFields:(PBUnknownFieldSet*) unknownFields;
+ (PBDynamicMessage*) defaultInstance:(PBDescriptor*) type;

+ (PBDynamicMessage_Builder*) builderWithType:(PBDescriptor*) type;
+ (PBDynamicMessage_Builder*) builderWithMessage:(id<PBMessage>) prototype;

+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
                       data:(NSData*) data;

@end