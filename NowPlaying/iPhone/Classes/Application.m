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
#import "Model.h"
#import "StringUtilities.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@implementation Application

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
static NSString* moviesPostersDirectory = nil;
static NSString* largeMoviesPostersDirectory = nil;
static NSString* largeMoviesPostersIndexDirectory = nil;
static NSString* peoplePostersDirectory = nil;
static NSString* largePeoplePostersDirectory = nil;

static NSString* dvdDirectory = nil;
static NSString* dvdDetailsDirectory = nil;

static NSString* blurayDirectory = nil;
static NSString* blurayDetailsDirectory = nil;

static NSString* netflixDirectory = nil;
static NSString* netflixSeriesDirectory = nil;
static NSString* netflixQueuesDirectory = nil;
static NSString* netflixUserRatingsDirectory = nil;
static NSString* netflixPredictedRatingsDirectory = nil;
static NSString* netflixSearchDirectory = nil;
static NSString* netflixDetailsDirectory = nil;
static NSString* netflixRSSDirectory = nil;

static NSString* upcomingDirectory = nil;
static NSString* upcomingCastDirectory = nil;
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
&blurayDirectory,
&blurayDetailsDirectory,
&netflixDirectory,
&netflixQueuesDirectory,
&netflixSeriesDirectory,
&netflixUserRatingsDirectory,
&netflixPredictedRatingsDirectory,
&netflixSearchDirectory,
&netflixDetailsDirectory,
&netflixRSSDirectory,
&scoresDirectory,
&reviewsDirectory,
&trailersDirectory,
&postersDirectory,
&moviesPostersDirectory,
&largeMoviesPostersDirectory,
&largeMoviesPostersIndexDirectory,
&peoplePostersDirectory,
&largePeoplePostersDirectory,
&upcomingDirectory,
&upcomingCastDirectory,
&upcomingSynopsesDirectory,
&upcomingTrailersDirectory,
};

static DifferenceEngine* differenceEngine = nil;


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


+ (void) initializeDirectories {
    {
        NSString* cacheDirectory = [self cacheDirectory];
        dataDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Data"] retain];
        imdbDirectory = [[cacheDirectory stringByAppendingPathComponent:@"IMDb"] retain];
        amazonDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Amazon"] retain];
        wikipediaDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Wikipedia"] retain];
        userLocationsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"UserLocations"] retain];
        scoresDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Scores"] retain];
        reviewsDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Reviews"] retain];
        trailersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Trailers"] retain];

        postersDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Posters"] retain];
        moviesPostersDirectory = [[postersDirectory stringByAppendingPathComponent:@"Movies"] retain];
        largeMoviesPostersDirectory = [[moviesPostersDirectory stringByAppendingPathComponent:@"Large"] retain];
        largeMoviesPostersIndexDirectory = [[largeMoviesPostersDirectory stringByAppendingPathComponent:@"Index"] retain];
        peoplePostersDirectory = [[postersDirectory stringByAppendingPathComponent:@"People"] retain];
        largePeoplePostersDirectory = [[peoplePostersDirectory stringByAppendingPathComponent:@"Large"] retain];

        dvdDirectory = [[cacheDirectory stringByAppendingPathComponent:@"DVD"] retain];
        dvdDetailsDirectory = [[dvdDirectory stringByAppendingPathComponent:@"Details"] retain];

        blurayDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Bluray"] retain];
        blurayDetailsDirectory = [[blurayDirectory stringByAppendingPathComponent:@"Details"] retain];

        netflixDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Netflix"] retain];
        netflixQueuesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Queues"] retain];
        netflixSeriesDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Series"] retain];
        netflixDetailsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Details"] retain];
        netflixUserRatingsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"UserRatings"] retain];
        netflixPredictedRatingsDirectory = [[netflixDirectory stringByAppendingPathComponent:@"PredictedRatings"] retain];
        netflixSearchDirectory = [[netflixDirectory stringByAppendingPathComponent:@"Search"] retain];
        netflixRSSDirectory = [[netflixDirectory stringByAppendingPathComponent:@"RSS"] retain];

        upcomingDirectory = [[cacheDirectory stringByAppendingPathComponent:@"Upcoming"] retain];
        upcomingCastDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Cast"] retain];
        upcomingSynopsesDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Synopses"] retain];
        upcomingTrailersDirectory = [[upcomingDirectory stringByAppendingPathComponent:@"Trailers"] retain];

        [self createDirectories];
    }
}


+ (void) initialize {
    if (self == [Application class]) {
        differenceEngine = [[DifferenceEngine engine] retain];

        [self initializeDirectories];
    }
}


+ (NSArray*) directoriesToKeep {
    return [NSArray arrayWithObject:userLocationsDirectory];
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


+ (NSString*) moviesPostersDirectory {
    return moviesPostersDirectory;
}


+ (NSString*) largeMoviesPostersDirectory {
    return largeMoviesPostersDirectory;
}


+ (NSString*) largeMoviesPostersIndexDirectory {
    return largeMoviesPostersIndexDirectory;
}


+ (NSString*) peoplePostersDirectory {
    return peoplePostersDirectory;
}


+ (NSString*) largePeoplePostersDirectory {
    return largePeoplePostersDirectory;
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


+ (NSString*) blurayDirectory {
    return blurayDirectory;
}


+ (NSString*) blurayDetailsDirectory {
    return blurayDetailsDirectory;
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


+ (NSString*) upcomingSynopsesDirectory {
    return upcomingSynopsesDirectory;
}


+ (NSString*) upcomingTrailersDirectory {
    return upcomingTrailersDirectory;
}


+ (void) resetDirectories {
    [[self gate] lock];
    {
        [self deleteDirectories];
        [self createDirectories];
    }
    [[self gate] unlock];
}


+ (void) resetNetflixDirectories {
    [[self gate] lock];
    {
        [self moveItemToTrash:netflixUserRatingsDirectory];
        [self moveItemToTrash:netflixPredictedRatingsDirectory];
        [self moveItemToTrash:netflixQueuesDirectory];
        [self createDirectories];
    }
    [[self gate] unlock];
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

@end