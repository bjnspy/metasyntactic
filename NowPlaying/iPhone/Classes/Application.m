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
static NSString* largePostersDirectory = nil;

static NSString* dvdDirectory = nil;
static NSString* dvdDetailsDirectory = nil;
static NSString* dvdIMDbDirectory = nil;
static NSString* dvdPostersDirectory = nil;

static NSString* blurayDirectory = nil;
static NSString* blurayDetailsDirectory = nil;
static NSString* blurayIMDbDirectory = nil;
static NSString* blurayPostersDirectory = nil;

static NSString* netflixDirectory = nil;
static NSString* netflixIMDbDirectory = nil;
static NSString* netflixCastDirectory = nil;
static NSString* netflixSeriesDirectory = nil;
static NSString* netflixQueuesDirectory = nil;
static NSString* netflixFormatsDirectory = nil;
static NSString* netflixPostersDirectory = nil;
static NSString* netflixSynopsesDirectory = nil;
static NSString* netflixDirectorsDirectory = nil;
static NSString* netflixUserRatingsDirectory = nil;
static NSString* netflixPredictedRatingsDirectory = nil;
static NSString* netflixSearchDirectory = nil;

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
&blurayDirectory,
&blurayDetailsDirectory,
&blurayIMDbDirectory,
&blurayPostersDirectory,
&netflixDirectory,
&netflixCastDirectory,
&netflixIMDbDirectory,
&netflixQueuesDirectory,
&netflixSeriesDirectory,
&netflixFormatsDirectory,
&netflixPostersDirectory,
&netflixSynopsesDirectory,
&netflixDirectorsDirectory,
&netflixUserRatingsDirectory,
&netflixPredictedRatingsDirectory,
&netflixSearchDirectory,
&scoresDirectory,
&reviewsDirectory,
&trailersDirectory,
&postersDirectory,
&largePostersDirectory,
&upcomingDirectory,
&upcomingCastDirectory,
&upcomingIMDbDirectory,
&upcomingPostersDirectory,
&upcomingSynopsesDirectory,
&upcomingTrailersDirectory,
};

static NSString* emptyStarString = nil;
static NSString* halfStarString = nil;
static NSString* starString = nil;

static DifferenceEngine* differenceEngine = nil;


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
            NSString* directory = *directories[i];

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
            NSString* directory = *directories[i];

            [FileUtilities createDirectory:directory];
        }
    }
    [gate unlock];
}


+ (void) initialize {
    if (self == [Application class]) {
        gate = [[NSRecursiveLock alloc] init];

        emptyStarString = [[Utilities stringFromUnichar:(unichar)0x2606] retain];
        halfStarString = [[Utilities stringFromUnichar:(unichar)0x272F] retain];
        starString = [[Utilities stringFromUnichar:[self starCharacter]] retain];

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
            largePostersDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"LargePosters"] retain];

            dvdDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"DVD"] retain];
            dvdDetailsDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"Details"] retain];
            dvdIMDbDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            dvdPostersDirectory = [[[self dvdDirectory] stringByAppendingPathComponent:@"Posters"] retain];

            blurayDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Bluray"] retain];
            blurayDetailsDirectory = [[[self blurayDirectory] stringByAppendingPathComponent:@"Details"] retain];
            blurayIMDbDirectory = [[[self blurayDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            blurayPostersDirectory = [[[self blurayDirectory] stringByAppendingPathComponent:@"Posters"] retain];

            netflixDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Netflix"] retain];
            netflixQueuesDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Queues"] retain];
            netflixPostersDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Posters"] retain];
            netflixSynopsesDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Synopses"] retain];
            netflixCastDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Cast"] retain];
            netflixDirectorsDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Directors"] retain];
            netflixIMDbDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            netflixSeriesDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Series"] retain];
            netflixFormatsDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Formats"] retain];
            netflixUserRatingsDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"UserRatings"] retain];
            netflixPredictedRatingsDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"PredictedRatings"] retain];
            netflixSearchDirectory = [[[self netflixDirectory] stringByAppendingPathComponent:@"Search"] retain];

            upcomingDirectory = [[[self cacheDirectory] stringByAppendingPathComponent:@"Upcoming"] retain];
            upcomingCastDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Cast"] retain];
            upcomingIMDbDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"IMDb"] retain];
            upcomingPostersDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Posters"] retain];
            upcomingSynopsesDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Synopses"] retain];
            upcomingTrailersDirectory = [[[self upcomingDirectory] stringByAppendingPathComponent:@"Trailers"] retain];

            [self createDirectories];
        }
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
        [FileUtilities removeItem:netflixUserRatingsDirectory];
        [FileUtilities removeItem:netflixPredictedRatingsDirectory];
        [self createDirectories];
    }
    [gate unlock];
}


+ (void) clearStaleData {
    [gate lock];
    {
        for (NSInteger i = 0; i < ArrayLength(directories); i++) {
            NSString* directory = *directories[i];

            if ([userLocationsDirectory isEqual:directory]) {
                continue;
            }

            for (NSString* path in [FileUtilities directoryContentsPaths:directory]) {
                if ([FileUtilities isDirectory:path]) {
                    continue;
                }

                NSDate* lastModifiedDate = [FileUtilities modificationDate:path];
                if (lastModifiedDate != nil) {
                    if (ABS(lastModifiedDate.timeIntervalSinceNow) > CACHE_LIMIT) {
                        [FileUtilities removeItem:path];
                    }
                }
            }
        }
    }
    [gate unlock];
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


+ (NSString*) dvdIMDbDirectory {
    return dvdIMDbDirectory;
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


+ (NSString*) blurayIMDbDirectory {
    return blurayIMDbDirectory;
}


+ (NSString*) blurayPostersDirectory {
    return blurayPostersDirectory;
}


+ (NSString*) netflixDirectory {
    return netflixDirectory;
}


+ (NSString*) netflixQueuesDirectory {
    return netflixQueuesDirectory;
}


+ (NSString*) netflixPostersDirectory {
    return netflixPostersDirectory;
}


+ (NSString*) netflixSynopsesDirectory {
    return netflixSynopsesDirectory;
}


+ (NSString*) netflixCastDirectory {
    return netflixCastDirectory;
}


+ (NSString*) netflixDirectorsDirectory {
    return netflixDirectorsDirectory;
}


+ (NSString*) netflixIMDbDirectory {
    return netflixIMDbDirectory;
}


+ (NSString*) netflixSeriesDirectory {
    return netflixSeriesDirectory;
}


+ (NSString*) netflixFormatsDirectory {
    return netflixFormatsDirectory;
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