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

#import "MainThreadGate.h"

@implementation FileUtilities

static MainThreadGate* gate;

+ (void) initialize {
    if (self == [FileUtilities class]) {
        gate = [[MainThreadGate gate] retain];
    }
}



+ (void) createDirectory:(NSString*) folder {
    [gate lock];
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    [gate unlock];
}


+ (NSDate*) modificationDate:(NSString*) file {
    NSDate* result;
    [gate lock];
    {
        result = [[[NSFileManager defaultManager] attributesOfItemAtPath:file
                                                                   error:NULL] objectForKey:NSFileModificationDate];
    }
    [gate unlock];
    return result;
}


+ (NSArray*) directoryContentsNames:(NSString*) directory {
    NSArray* result;
    [gate lock];
    {
        result = [[NSFileManager defaultManager] directoryContentsAtPath:directory];
    }
    [gate unlock];
    return result;
}


+ (NSArray*) directoryContentsPaths:(NSString*) directory {
    NSMutableArray* result = [NSMutableArray array];
    [gate lock];
    {
        NSArray* names = [[NSFileManager defaultManager] directoryContentsAtPath:directory];
        for (NSString* name in names) {
            [result addObject:[directory stringByAppendingPathComponent:name]];
        }
    }
    [gate unlock];
    return result;
}


+ (void) removeItem:(NSString*) path {
    [gate lock];
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
    [gate unlock];
}


+ (BOOL) fileExists:(NSString*) path {
    BOOL result;
    [gate lock];
    {
        result = [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    [gate unlock];
    return result;
}


+ (void) moveItem:(NSString*) from to:(NSString*) to {
    [gate lock];
    {
        [[NSFileManager defaultManager] moveItemAtPath:from toPath:to error:NULL];
    }
    [gate unlock];
}


+ (NSString*) sanitizeFileName:(NSString*) name {
    return [[name stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"]
            stringByReplacingOccurrencesOfString:@":" withString:@"-colon-"];
}


+ (void) writeObject:(id) object toFile:(NSString*) file {
    [gate lock];
    {
        NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:object
                                                                       format:NSPropertyListBinaryFormat_v1_0
                                                             errorDescription:NULL];
        if(plistData) {
            [plistData writeToFile:file atomically:YES];
        }
    }
    [gate unlock];
}


+ (id) readObject:(NSString*) file {
    if (file == nil) {
        return nil;
    }

    id result = nil;
    [gate lock];
    {
        NSData* data = [NSData dataWithContentsOfFile:file];
        if (data != nil) {
            result = [NSPropertyListSerialization propertyListFromData:data
                                                      mutabilityOption:NSPropertyListImmutable
                                                                format:NULL
                                                      errorDescription:NULL];
        }
    }
    [gate unlock];
    return result;
}


+ (void) writeData:(NSData*) data toFile:(NSString*) file {
    [gate lock];
    {
        [data writeToFile:file atomically:YES];
    }
    [gate unlock];
}


+ (NSData*) readData:(NSString*) file {
    if (file == nil) {
        return nil;
    }

    NSData* result = nil;
    [gate lock];
    {
        result = [NSData dataWithContentsOfFile:file];
    }
    [gate unlock];
    return result;
}

@end