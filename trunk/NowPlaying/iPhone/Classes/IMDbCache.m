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

#import "IMDbCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@interface IMDbCache()
@property (retain) LinkedSet* prioritizedMovies;
@end


@implementation IMDbCache

@synthesize prioritizedMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
    }

    return self;
}


+ (IMDbCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[IMDbCache alloc] initWithModel:model] autorelease];
}


- (NSString*) imdbFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application imdbDirectory] stringByAppendingPathComponent:name];
}


- (void) update:(NSArray*) movies {
    if (model.userAddress.length == 0) {
        return;
    }

    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:movies
                                   gate:gate
                                visible:NO];
}


- (void) downloadAddress:(Movie*) movie {
    if (movie.imdbAddress.length > 0) {
        // don't even bother if the movie has an imdb address in it
        return;
    }

    NSString* path = [self imdbFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:path];

    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:path];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }

        // we have a sentinel.  only update if it's been long enough
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupIMDbListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* imdbAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (imdbAddress == nil) {
        return;
    }

    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:imdbAddress toFile:path];
    if (imdbAddress.length > 0) {
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSMutableSet setWithObject:[Application imdbDirectory]];
}


- (NSSet*) cachedPathsToExclude {
    NSMutableSet* result = [NSMutableSet set];
    
    for (Movie* movie in model.allBookmarkedMovies) {
        [result addObject:[self imdbFile:movie]];
    }
    
    return result;
}



- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie;
    while ((movie = [prioritizedMovies removeLastObjectAdded]) != nil) {
        if (![FileUtilities fileExists:[self imdbFile:movie]]) {
            return movie;
        }
    }

    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }

    return nil;
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    NSMutableArray* mutableMovies = [NSMutableArray arrayWithArray:movies];
    Movie* movie = nil;
    do {
        movie = [self getNextMovie:mutableMovies];
        [self downloadAddress:movie];
    } while (movie != nil);
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self imdbFile:movie]];
}

@end