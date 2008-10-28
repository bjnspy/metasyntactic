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