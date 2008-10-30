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

#import "PosterCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Location.h"
#import "Movie.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PosterDownloader.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@implementation PosterCache

@synthesize updateGate;
@synthesize model;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.updateGate = nil;
    self.model = nil;
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.updateGate = [[[NSLock alloc] init] autorelease];
        self.model = model_;
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
    }

    return self;
}


+ (PosterCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[PosterCache alloc] initWithModel:model] autorelease];
}


- (void) update:(NSArray*) movies {
    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:[NSArray arrayWithArray:movies]
                                   gate:updateGate
                                visible:NO];
}


- (NSString*) posterFilePath:(Movie*) movie {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    return [[[Application postersFolder] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (void) deleteObsoletePosters:(NSArray*) movies {
    NSMutableSet* set = [NSMutableSet set];

    NSArray* contents = [FileUtilities directoryContents:[Application postersFolder]];
    for (NSString* fileName in contents) {
        NSString* filePath = [[Application postersFolder] stringByAppendingPathComponent:fileName];
        [set addObject:filePath];
    }

    for (Movie* movie in movies) {
        [set removeObject:[self posterFilePath:movie]];
    }

    for (NSString* filePath in set) {
        NSDate* downloadDate = [FileUtilities modificationDate:filePath];

        if (downloadDate != nil) {
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (ONE_HOUR * 1000)) {
                [FileUtilities removeItem:filePath];
            }
        }
    }
}


- (void) downloadPoster:(Movie*) movie
             postalCode:(NSString*) postalCode {
    if (movie == nil) {
        return;
    }

    NSString* path = [self posterFilePath:movie];

    if ([FileUtilities fileExists:path]) {
        return;
    }

    NSData* data = [PosterDownloader download:movie postalCode:postalCode];
    if (data != nil) {
        [FileUtilities writeData:data toFile:path];
        [NowPlayingAppDelegate refresh];
    }
}


- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie = [prioritizedMovies removeLastObjectAdded];

    if (movie != nil) {
        return movie;
    }

    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }

    return nil;
}


- (void) downloadPosters:(NSMutableArray*) movies
              postalCode:(NSString*) postalCode {
    Movie* movie;
    do {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            movie = [self getNextMovie:movies];
            [self downloadPoster:movie postalCode:postalCode];
        }
        [autoreleasePool release];
    } while (movie != nil);
}


- (void) downloadPosters:(NSArray*) movies {
    // movies with poster links download faster. try them first.
    NSMutableArray* moviesWithPosterLinks = [NSMutableArray array];
    NSMutableArray* moviesWithoutPosterLinks = [NSMutableArray array];

    for (Movie* movie in movies) {
        if (movie.poster.length == 0) {
            [moviesWithoutPosterLinks addObject:movie];
        } else {
            [moviesWithPosterLinks addObject:movie];
        }
    }

    Location* location = [model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:model.userAddress];
    NSString* postalCode = location.postalCode;
    if (postalCode == nil || ![@"US" isEqual:location.country]) {
        postalCode = @"10009";
    }

    [self downloadPosters:moviesWithPosterLinks postalCode:postalCode];
    [self downloadPosters:moviesWithoutPosterLinks postalCode:postalCode];
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    [self deleteObsoletePosters:movies];
    [self downloadPosters:movies];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [FileUtilities readData:path];
    return [UIImage imageWithData:data];
}


@end