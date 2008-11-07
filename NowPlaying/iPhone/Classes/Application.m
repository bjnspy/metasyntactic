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

#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "LocaleUtilities.h"
#import "Utilities.h"

@implementation Application

static NSLock* gate = nil;

// Special directories
static NSString* cacheDirectory = nil;
static NSString* supportDirectory = nil;
static NSString* tempDirectory = nil;

// Application storage directories
static NSString* dataDirectory = nil;
static NSString* imdbDirectory = nil;
static NSString* userLocationsDirectory = nil;
static NSString* scoresDirectory = nil;
static NSString* reviewsDirectory = nil;
static NSString* trailersDirectory = nil;
static NSString* postersDirectory = nil;
static NSString* postersLargeDirectory = nil;

static NSString* dvdDirectory = nil;
static NSString* dvdDetailsDirectory = nil;
static NSString* dvdIMDbDirectory = nil;
static NSString* dvdPostersDirectory = nil;

/*
static NSString* numbersDirectory = nil;
static NSString* numbersBudgetsDirectory = nil;
static NSString* numbersDailyDirectory = nil;
static NSString* numbersWeekendDirectory = nil;
*/

static NSString* upcomingDirectory = nil;
static NSString* upcomingCastDirectory = nil;
static NSString* upcomingIMDbDirectory = nil;
static NSString* upcomingPostersDirectory = nil;
static NSString* upcomingSynopsesDirectory = nil;
static NSString* upcomingTrailersDirectory = nil;

static NSString** directories[] = {
    &dataDirectory,
    &imdbDirectory,
    &userLocationsDirectory,
    &dvdDirectory,
    &dvdDetailsDirectory,
    &dvdIMDbDirectory,
    &dvdPostersDirectory,
/*
    &numbersDirectory,
    &numbersBudgetsDirectory,
    &numbersDailyDirectory,
    &numbersWeekendDirectory,
 */
    &scoresDirectory,
    &reviewsDirectory,
    &trailersDirectory,
    &postersDirectory,
    &postersLargeDirectory,
    &upcomingDirectory,
    &upcomingCastDirectory,
    &upcomingIMDbDirectory,
    &upcomingPostersDirectory,
    &upcomingSynopsesDirectory,
    &upcomingTrailersDirectory
};


static DifferenceEngine* differenceEngine = nil;
static NSString* starString = nil;


+ (NSString*) cacheDirectory {
    [gate lock];
    {
        if (cacheDirectory == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, /*expandTilde:*/YES);

            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];

            [FileUtilities createDirectory:directory];

            cacheDirectory = [directory retain];
        }
    }
    [gate unlock];

    return cacheDirectory;
}


+ (NSString*) supportDirectory {
    [gate lock];
    {
        if (supportDirectory == nil) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, /*expandTilde:*/YES);

            NSString* executableName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
            NSString* directory = [[paths objectAtIndex:0] stringByAppendingPathComponent:executableName];

            [FileUtilities createDirectory:directory];

            supportDirectory = [directory retain];
        }
    }
    [gate unlock];

    return supportDirectory;
}


+ (NSString*) tempDirectory {
    [gate lock];
    {
        if (tempDirectory == nil) {
            tempDirectory = [NSTemporaryDirectory() retain];
        }
    }
    [gate unlock];

    return tempDirectory;
}


+ (void) deleteDirectories {
    [gate lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString** directoryReference = directories[i];
            NSString* directory = *directoryReference;

            if (directory != nil) {
                [FileUtilities removeItem:directory];
            }
        }
    }
    [gate unlock];
}


+ (void) createDirectories {
    [gate lock];
    {
        for (int i = 0; i < ArrayLength(directories); i++) {
            NSString** directoryReference = directories[i];
            NSString* directory = *directoryReference;

            [FileUtilities createDirectory:directory];
        }
    }
    [gate unlock];
}


+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];

        differenceEngine = [[DifferenceEngine engine] retain];

        [FileUtilities removeItem:[self supportDirectory]];

        {
            dataDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Data"] retain];
            imdbDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            userLocationsDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"UserLocations"] retain];
            scoresDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Scores"] retain];
            reviewsDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Reviews"] retain];
            trailersDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Trailers"] retain];

            postersDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Posters"] retain];
            postersLargeDirectory = [[[self postersDirectory] stringByAppendingPathComponent:@"Large"] retain];

            dvdDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"DVD"] retain];
            dvdDetailsDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"Details"] retain];
            dvdIMDbDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            dvdPostersDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"Posters"] retain];

            upcomingDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Upcoming"] retain];
            upcomingCastDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Cast"] retain];
            upcomingIMDbDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            upcomingPostersDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Posters"] retain];
            upcomingSynopsesDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Synopses"] retain];
            upcomingTrailersDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Trailers"] retain];

            [self createDirectories];
//            static NSString* numbersDirectory = nil;
//            static NSString* numbersBudgetsDirectory = nil;
//            static NSString* numbersDailyDirectory = nil;
//            static NSString* numbersWeekendDirectory = nil;
        }
    }
}


+ (void) resetDirectories {
    [self deleteDirectories];
    [self createDirectories];
}


+ (NSString*) dataDirectory {
    return dataDirectory;
}


+ (NSString*) imdbDirectory {
    return imdbDirectory;
}


+ (NSString*) userLocationsDirectory {
    return userLocationsDirectory;
}

/*
+ (NSString*) numbersDirectory {
    return [self createDirectory:&numbersDirectory parent:[Application cacheDirectory] name:@"Numbers"];
}


+ (NSString*) numbersDetailsDirectory {
    return [self createDirectory:&numbersWeekendDirectory parent:[Application numbersDirectory] name:@"Details"];
}
 */


+ (NSString*) postersDirectory {
    return postersDirectory;
}


+ (NSString*) postersLargeDirectory {
    return postersLargeDirectory;
}


+ (NSString*) scoresDirectory {
    return scoresDirectory;
}


+ (NSString*) reviewsDirectory {
    return reviewsDirectory;
}


+ (NSString*) trailersDirectory {
    return trailersDirectory;
}


+ (NSString*) dvdDirectory {
    return dvdDirectory;
}


+ (NSString*) dvdDetailsDirectory {
    return dvdDetailsDirectory;
}


+ (NSString*) dvdIMDbDirectory {
    return dvdIMDbDirectory;
}


+ (NSString*) dvdPostersDirectory {
    return dvdPostersDirectory;
}


+ (NSString*) upcomingDirectory {
    return upcomingDirectory;
}


+ (NSString*) upcomingCastDirectory {
    return upcomingCastDirectory;
}


+ (NSString*) upcomingIMDbDirectory {
    return upcomingIMDbDirectory;
}


+ (NSString*) upcomingPostersDirectory {
    return upcomingPostersDirectory;
}


+ (NSString*) upcomingSynopsesDirectory {
    return upcomingSynopsesDirectory;
}


+ (NSString*) upcomingTrailersDirectory {
    return upcomingTrailersDirectory;
}


+ (NSString*) randomString {
    NSMutableString* string = [NSMutableString string];
    for (int i = 0; i < 8; i++) {
        [string appendFormat:@"%c", ((rand() % 26) + 'a')];
    }
    return string;
}


+ (NSString*) uniqueTemporaryDirectory {
    NSString* finalDir;

    [gate lock];
    {
        NSFileManager* manager = [NSFileManager defaultManager];

        NSString* tempDir = [Application tempDirectory];
        do {
            NSString* random = [Application randomString];
            finalDir = [tempDir stringByAppendingPathComponent:random];
        } while ([manager fileExistsAtPath:finalDir]);

        [FileUtilities createDirectory:finalDir];
    }
    [gate unlock];

    return finalDir;
}


+ (void) openBrowser:(NSString*) address {
    if (address.length == 0) {
        return;
    }

    NSURL* url = [NSURL URLWithString:address];
    [[UIApplication sharedApplication] openURL:url];
}


+ (void) openMap:(NSString*) address {
    [self openBrowser:address];
}


+ (void) makeCall:(NSString*) phoneNumber {
    if (![[[UIDevice currentDevice] model] isEqual:@"iPhone"]) {
        return;
    }

    NSRange xRange = [phoneNumber rangeOfString:@"x"];
    if (xRange.length > 0 && xRange.location >= 12) {
        // 222-222-2222 x222
        // remove extension
        phoneNumber = [phoneNumber substringToIndex:xRange.location];
    }

    NSString* urlString = [NSString stringWithFormat:@"tel:%@", [Utilities stringByAddingPercentEscapes:phoneNumber]];

    [self openBrowser:urlString];
}


+ (DifferenceEngine*) differenceEngine {
    NSAssert([NSThread isMainThread], @"Cannot access difference engine from background thread.");
    return differenceEngine;
}


+ (NSString*) host {
#if !TARGET_IPHONE_SIMULATOR
    return @"metaboxoffice2";
#endif
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


+ (BOOL) useKilometers {
    // yeah... so the UK supposedly uses metric...
    // except they don't. so we special case them to stick with 'miles' in the UI.
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    BOOL isUK = [@"GB" isEqual:[LocaleUtilities isoCountry]];

    return isMetric && !isUK;
}


@end