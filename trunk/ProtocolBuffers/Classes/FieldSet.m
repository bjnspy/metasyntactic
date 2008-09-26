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

#import "FieldSet.h"

#import "CodedInputStream.h"


@implementation FieldSet

+ (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder {
    while (true) {
        int32_t tag = [input readTag];
        if (tag == 0) {
            break;
        }
        
        if (![self mergeFieldFromCodedInputStream:input
                                    unknownFields:unknownFields
                                extensionRegistry:extensionRegistry
                                          builder:builder
                                              tag:tag]) {
            // end group tag
            break;
        }
    }
}



+ (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input
                          unknownFields:(UnknownFieldSet_Builder*) unknownFields
                      extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                builder:(id<Message_Builder>) builder
                                    tag:(int32_t) tag {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

@end
