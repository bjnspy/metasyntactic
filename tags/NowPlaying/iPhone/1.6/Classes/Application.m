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

#import "Application.h"

#import "DifferenceEngine.h"
#import "Utilities.h"

@implementation Application

static NSLock* gate = nil;

static NSString* dataFolder = nil;
static NSString* documentsFolder = nil;
static NSString* tempFolder = nil;
static NSString* locationsFolder = nil;
static NSString* ratingsFolder = nil;
static NSString* reviewsFolder = nil;
static NSString* trailersFolder = nil;
static NSString* postersFolder = nil;
static NSString* supportFolder = nil;

static NSString* numbersFolder = nil;
static NSString* numbersBudgetsFolder = nil;
static NSString* numbersDailyFolder = nil;
static NSString* numbersWeekendFolder = nil;

static NSString* upcomingFolder = nil;
static NSString* upcomingPostersFolder = nil;
static NSString* upcomingSynopsesFolder = nil;
static NSString* upcomingTrailersFolder = nil;

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
        NSString** folders[] = {
            &dataFolder,
            &documentsFolder,
            &tempFolder,
            &locationsFolder,
            &numbersFolder,
            &numbersBudgetsFolder,
            &numbersDailyFolder,
            &numbersWeekendFolder,
            &ratingsFolder,
            &reviewsFolder,
            &trailersFolder,
            &postersFolder,
            &supportFolder,
            &upcomingFolder,
            &upcomingPostersFolder,
            &upcomingSynopsesFolder,
            &upcomingTrailersFolder
        };

        for (int i = 0; i < ArrayLength(folders); i++) {
            NSString** folderReference = folders[i];
            NSString* folder = *folderReference;

            if (folder != nil) {
                [[NSFileManager defaultManager] removeItemAtPath:folder error:NULL];
                [folder release];
                *folderReference = nil;
            }
        }

        [providerReviewsFolder release];
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

+ (NSString*) findOrCreateFolder:(NSString**) folder parent:(NSString*) parent name:(NSString*) child {
    [gate lock];
    {
        if (*folder == nil) {
            NSString* result = [parent stringByAppendingPathComponent:child];
            [Application createDirectory:result];
            *folder = [result retain];
        }
    }
    [gate unlock];

    return *folder;
}


+ (NSString*) dataFolder {
    return [self findOrCreateFolder:&dataFolder parent:[Application supportFolder] name:@"Data"];
}


+ (NSString*) locationsFolder {
    return [self findOrCreateFolder:&locationsFolder parent:[Application supportFolder] name:@"Locations"];
}


+ (NSString*) numbersFolder {
    return [self findOrCreateFolder:&numbersFolder parent:[Application supportFolder] name:@"Numbers"];
}


+ (NSString*) numbersDetailsFolder {
    return [self findOrCreateFolder:&numbersWeekendFolder parent:[Application numbersFolder] name:@"Details"];
}


+ (NSString*) postersFolder {
    return [self findOrCreateFolder:&postersFolder parent:[Application supportFolder] name:@"Posters"];
}


+ (NSString*) ratingsFolder {
    return [self findOrCreateFolder:&ratingsFolder parent:[Application supportFolder] name:@"Ratings"];
}


+ (NSString*) reviewsFolder {
    return [self findOrCreateFolder:&reviewsFolder parent:[Application supportFolder] name:@"Reviews"];
}


+ (NSString*) trailersFolder {
    return [self findOrCreateFolder:&trailersFolder parent:[Application supportFolder] name:@"Trailers"];
}


+ (NSString*) upcomingFolder {
    return [self findOrCreateFolder:&upcomingFolder parent:[Application supportFolder] name:@"Upcoming"];
}


+ (NSString*) upcomingPostersFolder {
    return [self findOrCreateFolder:&upcomingPostersFolder parent:[Application upcomingFolder] name:@"Posters"];
}


+ (NSString*) upcomingSynopsesFolder {
    return [self findOrCreateFolder:&upcomingSynopsesFolder parent:[Application upcomingFolder] name:@"Synopses"];
}


+ (NSString*) upcomingTrailersFolder {
    return [self findOrCreateFolder:&upcomingTrailersFolder parent:[Application upcomingFolder] name:@"Trailers"];
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


+ (NSString*) upcomingMoviesIndexFile {
    return [[Application upcomingFolder] stringByAppendingPathComponent:@"Index.plist"];
}


+ (NSString*) ratingsFile:(NSString*) provider {
    return [[[Application ratingsFolder] stringByAppendingPathComponent:provider] stringByAppendingPathExtension:@"plist"];
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
     [Utilities stringByAddingPercentEscapes:address]];

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
    return [[name stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"]
                  stringByReplacingOccurrencesOfString:@":" withString:@"-colon-"];
}


+ (BOOL) useKilometers {
    // yeah... so the UK supposedly uses metric...
    // except they don't. so we special case them to stick with 'miles' in the UI.
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    BOOL isUK = [@"GB" isEqual:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];

    return isMetric && !isUK;
}


@end