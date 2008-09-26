// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Message.h"

@interface AbstractMessage : NSObject<Message> {
}
#if 0
    int32_t memoizedSize;
}

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(CodedOutputStream*) output;
- (NSData*) toData;
- (void) writeToOutputStream:(NSOutputStream*) output;

- (int32_t) serializedSize;
#endif

- (Descriptor*) getDescriptorForType;
- (id<Message>) getDefaultInstanceForType;
- (NSDictionary*) getAllFields;
- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;
- (UnknownFieldSet*) getUnknownFields;
- (BOOL) isInitialized;
- (int32_t) getSerializedSize;
- (void) writeToCodedOutputStream:(CodedOutputStream*) output;
- (void) writeToOuputStream:(NSOutputStream*) output;
- (NSData*) toData;
- (id<Message_Builder>) newBuilderForType;

@end