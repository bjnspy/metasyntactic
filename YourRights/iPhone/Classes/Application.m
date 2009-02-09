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

#import "Application.h"

#import "FileUtilities.h"
#import "Model.h"
#import "ThreadingUtilities.h"

@implementation Application

static NSLock* gate = nil;

// Special directories
static NSString* cacheDirectory = nil;
static NSString* supportDirectory = nil;
static NSString* tempDirectory = nil;
static NSString* trashDirectory = nil;

// Application storage directories
static NSString* rssDirectory = nil;

static NSString** directories[] = {
&rssDirectory,
};


+ (void) deleteDirectories {
    [gate lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            if (directory != nil) {
                [self moveItemToTrash:directory];
            }
        }
    }
    [gate unlock];
}


+ (void) createDirectories {
    [gate lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            [FileUtilities createDirectory:directory];
        }
    }
    [gate unlock];
}


+ (void) emptyTrash {
    [ThreadingUtilities backgroundSelector:@selector(emptyTrashBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                   visible:NO];
}


+ (void) initializeDirectories {
    tempDirectory = [NSTemporaryDirectory() retain];

    {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, /*expandTilde:*/YES);
        NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
        [FileUtilities createDirectory:directory];
        cacheDirectory = [directory retain];
    }

    {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);
        NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];
        [FileUtilities createDirectory:directory];
        supportDirectory = [directory retain];
    }

    {
        NSString* directory = [cacheDirectory stringByAppendingPathComponent:@"Trash"];
        [FileUtilities createDirectory:directory];
        trashDirectory = [directory retain];
    }

    {
        rssDirectory = [[cacheDirectory stringByAppendingPathComponent:@"RSS"] retain];

        [self createDirectories];
    }
}


+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];

        [self initializeDirectories];

        [self emptyTrash];
    }
}


+ (void) emptyTrashBackgroundEntryPoint {
    for (NSString* path in [FileUtilities directoryContentsPaths:[self trashDirectory]]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}


+ (void) resetDirectories {
    [gate lock];
    {
        [self deleteDirectories];
        [self createDirectories];
    }
    [gate unlock];
}


+ (void) clearStaleData:(NSString*) directory {
    NSArray* names = [FileUtilities directoryContentsNames:directory];
    for (NSString* name in names) {
        // clear 5% of the old directories
        if ((rand() % 1000) < 50) {
            NSString* path = [directory stringByAppendingPathComponent:name];
            NSDictionary* attributes = [FileUtilities attributesOfItemAtPath:path];

            if ([[attributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory]) {
                // don't delete folders
                continue;
            }

            NSDate* lastModifiedDate = [attributes objectForKey:NSFileModificationDate];
            if (lastModifiedDate != nil) {
                if (ABS(lastModifiedDate.timeIntervalSinceNow) > CACHE_LIMIT) {
                    [self moveItemToTrash:path];
                }
            }
        }
    }
}


+ (void) clearStaleData {
    [gate lock];
    {
        for (NSInteger i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            [self clearStaleData:directory];
        }
    }
    [gate unlock];
}


+ (NSString*) randomString {
    NSMutableString* string = [NSMutableString string];
    for (int i = 0; i < 8; i++) {
        [string appendFormat:@"%c", ((rand() % 26) + 'a')];
    }
    return string;
}


+ (NSString*) uniqueDirectory:(NSString*) parentDirectory
                       create:(BOOL) create {
    NSString* finalDir;

    [gate lock];
    {
        do {
            NSString* random = [Application randomString];
            finalDir = [parentDirectory stringByAppendingPathComponent:random];
        } while ([[NSFileManager defaultManager] fileExistsAtPath:finalDir]);

        if (create) {
            [FileUtilities createDirectory:finalDir];
        }
    }
    [gate unlock];

    return finalDir;
}


+ (NSString*) uniqueTemporaryDirectory {
    return [self uniqueDirectory:[Application tempDirectory] create:YES];
}


+ (NSString*) uniqueTrashDirectory {
    return [self uniqueDirectory:[Application trashDirectory] create:NO];
}


+ (void) moveItemToTrash:(NSString*) path {
    [gate lock];
    {
        NSString* trashPath = [self uniqueTrashDirectory];
        [[NSFileManager defaultManager] moveItemAtPath:path toPath:trashPath error:NULL];
    }
    [gate unlock];
}


+ (NSString*) cacheDirectory {
    return cacheDirectory;
}


+ (NSString*) supportDirectory {
    return supportDirectory;
}


+ (NSString*) trashDirectory {
    return trashDirectory;
}


+ (NSString*) tempDirectory {
    return tempDirectory;
}


+ (NSString*) rssDirectory {
    return rssDirectory;
}


+ (NSString*) name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


+ (NSString*) nameAndVersion {
    NSString* appName = [self name];
    NSString* appVersion = [Model version];
    appVersion = [appVersion substringToIndex:[appVersion rangeOfString:@"." options:NSBackwardsSearch].location];

    return [NSString stringWithFormat:@"%@ v%@", appName, appVersion];
}

@end