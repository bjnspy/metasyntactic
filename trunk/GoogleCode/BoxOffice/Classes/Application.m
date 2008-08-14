// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "Application.h"

#import "DifferenceEngine.h"
#import "Utilities.h"

@implementation Application

static NSRecursiveLock* gate = nil;

static NSString* dataFolder = nil;
static NSString* documentsFolder = nil;
static NSString* tempFolder = nil;
static NSString* locationsFolder = nil;
static NSString* ratingsFolder = nil;
static NSString* reviewsFolder = nil;
static NSString* trailersFolder = nil;
static NSString* postersFolder = nil;
static NSString* searchFolder = nil;
static NSString* supportFolder = nil;
static NSMutableDictionary* providerReviewsFolder = nil;

static DifferenceEngine* differenceEngine = nil;
static NSString* starString = nil;

+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];

        differenceEngine = [[DifferenceEngine engine] retain];

        providerReviewsFolder = [[NSMutableDictionary dictionary] retain];
    }
}


+ (void) createDirectory:(NSString*) folder {
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}


+ (void) deleteFolders {
    [gate lock];
    {
        [[NSFileManager defaultManager] removeItemAtPath:[Application dataFolder] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application locationsFolder] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application postersFolder] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application trailersFolder] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application ratingsFolder] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application reviewsFolder] error:NULL];

        [dataFolder release];
        [locationsFolder release];
        [postersFolder release];
        [trailersFolder release];
        [ratingsFolder release];
        [reviewsFolder release];
        [providerReviewsFolder release];

        dataFolder = nil;
        locationsFolder = nil;
        postersFolder = nil;
        trailersFolder = nil;
        ratingsFolder = nil;
        reviewsFolder = nil;
        providerReviewsFolder = [[NSMutableDictionary dictionary] retain];
    }
    [gate unlock];
}


+ (NSString*) documentsFolder {
    [gate lock];
    {
        if (documentsFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, /*expandTilde:*/YES);
            NSString* folder = [paths objectAtIndex:0];

            [Application createDirectory:folder];

            documentsFolder = [folder retain];
        }
    }
    [gate unlock];

    return documentsFolder;
}


+ (NSString*) supportFolder {
    [gate lock];
    {
        if (supportFolder == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);

            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];

            [Application createDirectory:folder];

            supportFolder = [folder retain];
        }
    }
    [gate unlock];

    return supportFolder;
}


+ (NSString*) tempFolder {
    [gate lock];
    {
        if (tempFolder == nil) {
            tempFolder = [NSTemporaryDirectory() retain];
        }
    }
    [gate unlock];

    return tempFolder;
}


+ (NSString*) dataFolder {
    [gate lock];
    {
        if (dataFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Data"];

            [Application createDirectory:folder];

            dataFolder = [folder retain];
        }
    }
    [gate unlock];

    return dataFolder;
}


+ (NSString*) reviewsFolder {
    [gate lock];
    {
        if (reviewsFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Reviews"];

            [Application createDirectory:folder];

            reviewsFolder = [folder retain];
        }
    }
    [gate unlock];

    return reviewsFolder;
}


+ (NSString*) ratingsFolder {
    [gate lock];
    {
        if (ratingsFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Ratings"];

            [Application createDirectory:folder];

            ratingsFolder = [folder retain];
        }
    }
    [gate unlock];

    return ratingsFolder;
}


+ (NSString*) searchFolder {
    [gate lock];
    {
        if (searchFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Search"];

            [Application createDirectory:folder];

            searchFolder = [folder retain];
        }
    }
    [gate unlock];

    return searchFolder;
}


+ (NSString*) trailersFolder {
    [gate lock];
    {
        if (trailersFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Trailers"];

            [Application createDirectory:folder];

            trailersFolder = [folder retain];
        }
    }
    [gate unlock];

    return trailersFolder;
}


+ (NSString*) locationsFolder {
    [gate lock];
    {
        if (locationsFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Locations"];

            [Application createDirectory:folder];

            locationsFolder = [folder retain];
        }
    }
    [gate unlock];

    return locationsFolder;
}


+ (NSString*) postersFolder {
    [gate lock];
    {
        if (postersFolder == nil) {
            NSString* parent = [Application supportFolder];
            NSString* folder = [parent stringByAppendingPathComponent:@"Posters"];

            [Application createDirectory:folder];

            postersFolder = [folder retain];
        }
    }
    [gate unlock];

    return postersFolder;
}


+ (NSString*) providerReviewsFolder:(NSString*) ratingsProvider {
    NSString* folder = nil;

    [gate lock];
    {
        folder = [providerReviewsFolder objectForKey:ratingsProvider];
        if (folder == nil) {
            folder = [[Application reviewsFolder] stringByAppendingPathComponent:ratingsProvider];

            [Application createDirectory:folder];

            [providerReviewsFolder setObject:folder forKey:ratingsProvider];
        }
    }
    [gate unlock];

    return folder;
}


+ (NSString*) randomString {
    NSMutableString* string = [NSMutableString string];
    for (int i = 0; i < 8; i++) {
        [string appendFormat:@"%c", ((rand() % 26) + 'a')];
    }
    return string;
}


+ (NSString*) uniqueTemporaryFolder {
    NSString* finalDir;

    [gate lock];
    {
        NSFileManager* manager = [NSFileManager defaultManager];

        NSString* tempDir = [Application tempFolder];
        do {
            NSString* random = [Application randomString];
            finalDir = [tempDir stringByAppendingPathComponent:random];
        } while ([manager fileExistsAtPath:finalDir]);

        [Application createDirectory:finalDir];
    }
    [gate unlock];

    return finalDir;
}


+ (NSString*) movieMapFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"MovieMap.plist"];
}


+ (NSString*) moviesFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Movies.plist"];
}


+ (NSString*) ratingsFile:(NSString*) provider {
    return [[[Application ratingsFolder] stringByAppendingPathComponent:provider] stringByAppendingPathExtension:@"plist"];
}


+ (NSString*) theatersFile {
    return [[Application dataFolder] stringByAppendingPathComponent:@"Theaters.plist"];
}


+ (void) openBrowser:(NSString*) address {
    if ([Utilities isNilOrEmpty:address]) {
        return;
    }

    NSURL* url = [NSURL URLWithString:address];
    [[UIApplication sharedApplication] openURL:url];
}


+ (void) openMap:(NSString*) address {
    NSString* urlString =
    [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",
     [address stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]];

    [self openBrowser:urlString];
}


+ (void) makeCall:(NSString*) phoneNumber {
    if (![[[UIDevice currentDevice] model] isEqual:@"iPhone"]) {
        // can't make a phonecall if you're not an iPhone.
        return;
    }

    NSString* urlString = [NSString stringWithFormat:@"tel:%@", phoneNumber];

    [self openBrowser:urlString];
}


+ (DifferenceEngine*) differenceEngine {
    NSAssert([NSThread isMainThread], @"Cannot access difference engine from background thread.");
    return differenceEngine;
}


+ (NSString*) searchHost {
    //return @"http://metaboxoffice6.appspot.com";
    return @"http://localhost:8086";
}


+ (NSString*) host {
     /*
     return @"metaboxoffice6";
    /*/
    return @"metaboxoffice2";
    //*/
}


+ (unichar) starCharacter {
    return (unichar)0x2605;
}


+ (NSString*) starString {
    if (starString == nil) {
        unichar c = [Application starCharacter];
        starString = [NSString stringWithCharacters:&c length:1];
    }

    return starString;
}


+ (NSString*) sanitizeFileName:(NSString*) name {
    return [[[name stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"]
                   stringByReplacingOccurrencesOfString:@"." withString:@"-dot-"]
                   stringByReplacingOccurrencesOfString:@":" withString:@"-colon-"];
}


@end
