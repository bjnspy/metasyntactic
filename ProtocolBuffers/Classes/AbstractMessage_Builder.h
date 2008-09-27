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

#import "Message_Builder.h"

@interface AbstractMessage_Builder : NSObject<Message_Builder> {

}


- (id<Message_Builder>) mergeFrom:(CodedInputStream*) input
                extensionRegistry:(ExtensionRegistry*) extensionRegistry;

- (UnknownFieldSet*) getUnknownFields;

- (id<Message>) buildParsed;

#if 0
- (AbstractMessage_Builder*) clone;
- (AbstractMessage_Builder*) clear;
- (AbstractMessage_Builder*) mergeFrom:(id<Message>) other; 
- (AbstractMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input;
- (AbstractMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (AbstractMessage_Builder*) mergeUnknownFields:(UnknownFieldSet*) unknownFields;    
- (AbstractMessage_Builder*) mergeFromData:(NSData*) data;    
- (AbstractMessage_Builder*) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;    
- (AbstractMessage_Builder*) mergeFromInputStream:(NSInputStream*) input;
- (AbstractMessage_Builder*) mergeFromInputStream:(NSInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;    
#endif

@end
