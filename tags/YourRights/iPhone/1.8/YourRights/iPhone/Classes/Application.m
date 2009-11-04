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

#import "Model.h"

@implementation Application

// Application storage directories
static NSString* rssDirectory = nil;

static NSString** directories[] = {
&rssDirectory,
};


+ (void) deleteDirectories {
    [[self gate] lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            if (directory != nil) {
                [self moveItemToTrash:directory];
            }
        }
    }
    [[self gate] unlock];
}


+ (void) createDirectories {
    [[self gate] lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            [FileUtilities createDirectory:directory];
        }
    }
    [[self gate] unlock];
}


+ (void) resetDirectories {
    [[self gate] lock];
    {
        [self deleteDirectories];
        [self createDirectories];
    }
    [[self gate] unlock];
}


+ (void) initializeDirectories {
    {
        rssDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"RSS"] retain];

        [self createDirectories];
    }
}


+ (void) initialize {
    if (self == [Application class]) {
        [self initializeDirectories];
    }
}


+ (NSArray*) directoriesToKeep {
    return [NSArray array];
}


+ (NSString*) rssDirectory {
    return rssDirectory;
}

@end
