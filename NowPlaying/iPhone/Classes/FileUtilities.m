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

#import "FileUtilities.h"


@implementation FileUtilities


+ (void) createDirectory:(NSString*) folder {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}


+ (NSString*) sanitizeFileName:(NSString*) name {
    return [[name stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"]
            stringByReplacingOccurrencesOfString:@":" withString:@"-colon-"];
}


+ (void) writeObject:(id) object toFile:(NSString*) file {
    NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:object
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                         errorDescription:NULL];
    if(plistData) {
        [plistData writeToFile:file atomically:YES];
    }
}


+ (id) readObject:(NSString*) file {
    NSData* data = [NSData dataWithContentsOfFile:file];
    if (data == nil) {
        return nil;
    }

    return [NSPropertyListSerialization propertyListFromData:data
                                            mutabilityOption:NSPropertyListImmutable
                                                      format:NULL
                                            errorDescription:NULL];
}

@end
