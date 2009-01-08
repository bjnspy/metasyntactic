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
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation Application

static NSLock* gate = nil;

// Special directories
static NSString* cacheDirectory = nil;
static NSString* supportDirectory = nil;
static NSString* tempDirectory = nil;
static NSString* trashDirectory = nil;

// Application storage directories
static NSString* dataDirectory = nil;
static NSString* imdbDirectory = nil;
static NSString* amazonDirectory = nil;
static NSString* wikipediaDirectory = nil;
static NSString* userLocationsDirectory = nil;
static NSString* scoresDirectory = nil;
static NSString* reviewsDirectory = nil;
static NSString* trailersDirectory = nil;
static NSString* postersDirectory = nil;
static NSString* largePostersDirectory = nil;

static NSString* dvdDirectory = nil;
static NSString* dvdDetailsDirectory = nil;
static NSString* dvdPostersDirectory = nil;

static NSString* blurayDirectory = nil;
static NSString* blurayDetailsDirectory = nil;
static NSString* blurayPostersDirectory = nil;

static NSString* netflixDirectory = nil;
static NSString* netflixSeriesDirectory = nil;
static NSString* netflixQueuesDirectory = nil;
static NSString* netflixPostersDirectory = nil;
static NSString* netflixUserRatingsDirectory = nil;
static NSString* netflixPredictedRatingsDirectory = nil;
static NSString* netflixSearchDirectory = nil;
static NSString* netflixDetailsDirectory = nil;
static NSString* netflixRSSDirectory = nil;

static NSString* upcomingDirectory = nil;
static NSString* upcomingCastDirectory = nil;
static NSString* upcomingPostersDirectory = nil;
static NSString* upcomingSynopsesDirectory = nil;
static NSString* upcomingTrailersDirectory = nil;

static NSString** directories[] = {
&dataDirectory,
&imdbDirectory,
&amazonDirectory,
&wikipediaDirectory,
&userLocationsDirectory,
&dvdDirectory,
&dvdDetailsDirectory,
&dvdPostersDirectory,
&blurayDirectory,
&blurayDetailsDirectory,
&blurayPostersDirectory,
&netflixDirectory,
&netflixQueuesDirectory,
&netflixSeriesDirectory,
&netflixPostersDirectory,
&netflixUserRatingsDirectory,
&netflixPredictedRatingsDirectory,
&netflixSearchDirectory,
&netflixDetailsDirectory,
&netflixRSSDirectory,
&scoresDirectory,
&reviewsDirectory,
&trailersDirectory,
&postersDirectory,
&largePostersDirectory,
&upcomingDirectory,
&upcomingCastDirectory,
&upcomingPostersDirectory,
&upcomingSynopsesDirectory,
&upcomingTrailersDirectory,
};

static NSString* emptyStarString = nil;
static NSString* halfStarString = nil;
static NSString* starString = nil;

static DifferenceEngine* differenceEngine = nil;


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
        dataDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Data"] retain];
        imdbDirectory = [[cacheDirectory stringByAppendingPathComponent:@"IMDb"] retain];
        amazonDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Amazon"] retain];
        wikipediaDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Wikipedia"] retain];
        userLocationsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"UserLocations"] retain];
        scoresDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Scores"] retain];
        reviewsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Reviews"] retain];
        trailersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Trailers"] retain];

        postersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Posters"] retain];
        largePostersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"LargePosters"] retain];

        dvdDirectory = [[cacheDirectory stringByAppendingPathComponent:@"DVD"] retain];
        dvdDetailsDirectory = [[dvdDirectory stringByAppendingPathComponent:@"Details"] retain];
        dvdPostersDirectory = [[dvdDirectory stringByAppendingPathComponent:@"Posters"] retain];

        blurayDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Bluray"] retain];
        blurayDetailsDirectory = [[blurayDirectory stringByAppendingPathComponent:@"Details"] retain];
        blurayPostersDirectory = [[blurayDirectory stringByAppendingPathComponent:@"Posters"] retain];

        netflixDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Netflix"] retain];
        netflixQueuesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Queues"] retain];
        netflixPostersDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Posters"] retain];
        netflixSeriesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Series"] retain];
        netflixDetailsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Details"] retain];
        netflixUserRatingsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"UserRatings"] retain];
        netflixPredictedRatingsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"PredictedRatings"] retain];
        netflixSearchDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Search"] retain];
        netflixRSSDirectory = [[netflixDirectory stringByAppendingPathComponent:@"RSS"] retain];

        upcomingDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Upcoming"] retain];
        upcomingCastDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Cast"] retain];
        upcomingPostersDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Posters"] retain];
        upcomingSynopsesDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Synopses"] retain];
        upcomingTrailersDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Trailers"] retain];

        [self createDirectories];
    }
}


+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];

        emptyStarString = [[Utilities stringFromUnichar:(unichar)0x2606] retain];
        halfStarString = [[Utilities stringFromUnichar:(unichar)0x272F] retain];
        starString = [[Utilities stringFromUnichar:[self starCharacter]] retain];

        differenceEngine = [[DifferenceEngine engine] retain];

        [self initializeDirectories];
        [self moveItemToTrash:supportDirectory];

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


+ (void) resetNetflixDirectories {
    [gate lock];
    {
        [self moveItemToTrash:netflixUserRatingsDirectory];
        [self moveItemToTrash:netflixPredictedRatingsDirectory];
        [self moveItemToTrash:netflixQueuesDirectory];
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
            if ([netflixRSSDirectory isEqual:directory] ||
                [userLocationsDirectory isEqual:directory]) {
                continue;
            }

            [self clearStaleData:directory];
        }

        for (NSString* path in [FileUtilities directoryContentsPaths:netflixRSSDirectory]) {
            if ([FileUtilities isDirectory:path]) {
                [self clearStaleData:path];
            }
        }
    }
    [gate unlock];
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


+ (NSString*) dataDirectory {
    return dataDirectory;
}


+ (NSString*) imdbDirectory {
    return imdbDirectory;
}


+ (NSString*) amazonDirectory {
    return amazonDirectory;
}


+ (NSString*) wikipediaDirectory {
    return wikipediaDirectory;
}


+ (NSString*) userLocationsDirectory {
    return userLocationsDirectory;
}


+ (NSString*) postersDirectory {
    return postersDirectory;
}


+ (NSString*) largePostersDirectory {
    return largePostersDirectory;
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


+ (NSString*) dvdPostersDirectory {
    return dvdPostersDirectory;
}


+ (NSString*) blurayDirectory {
    return blurayDirectory;
}


+ (NSString*) blurayDetailsDirectory {
    return blurayDetailsDirectory;
}


+ (NSString*) blurayPostersDirectory {
    return blurayPostersDirectory;
}


+ (NSString*) netflixDirectory {
    return netflixDirectory;
}


+ (NSString*) netflixDetailsDirectory {
    return netflixDetailsDirectory;
}


+ (NSString*) netflixQueuesDirectory {
    return netflixQueuesDirectory;
}


+ (NSString*) netflixPostersDirectory {
    return netflixPostersDirectory;
}


+ (NSString*) netflixSeriesDirectory {
    return netflixSeriesDirectory;
}


+ (NSString*) netflixUserRatingsDirectory {
    return netflixUserRatingsDirectory;
}


+ (NSString*) netflixPredictedRatingsDirectory {
    return netflixPredictedRatingsDirectory;
}


+ (NSString*) netflixSearchDirectory {
    return netflixSearchDirectory;
}


+ (NSString*) netflixRSSDirectory {
    return netflixRSSDirectory;
}


+ (NSString*) upcomingDirectory {
    return upcomingDirectory;
}


+ (NSString*) upcomingCastDirectory {
    return upcomingCastDirectory;
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

+ (NSString*) emptyStarString {
    return emptyStarString;
}


+ (unichar) starCharacter {
    return (unichar)0x2605;
}


+ (NSString*) halfStarString {
    return halfStarString;
}


+ (NSString*) starString {
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