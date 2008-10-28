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
#import "Location.h"
#import "Movie.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PosterDownloader.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@implementation PosterCache

@synthesize gate;
@synthesize model;

- (void) dealloc {
    self.gate = nil;
    self.model = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.model = model_;
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
                                   gate:gate
                                visible:NO];
}


- (NSString*) posterFilePath:(Movie*) movie {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    return [[[Application postersFolder] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (void) deleteObsoletePosters:(NSArray*) movies {
    NSMutableSet* set = [NSMutableSet set];

    NSArray* contents = [[NSFileManager defaultManager] directoryContentsAtPath:[Application postersFolder]];
    for (NSString* fileName in contents) {
        NSString* filePath = [[Application postersFolder] stringByAppendingPathComponent:fileName];
        [set addObject:filePath];
    }

    for (Movie* movie in movies) {
        [set removeObject:[self posterFilePath:movie]];
    }

    for (NSString* filePath in set) {
        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] objectForKey:NSFileModificationDate];

        if (downloadDate != nil) {
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (ONE_HOUR * 1000)) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            }
        }
    }
}


- (void) downloadPoster:(Movie*) movie
             postalCode:(NSString*) postalCode {
    NSString* path = [self posterFilePath:movie];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return;
    }

    NSData* data = [PosterDownloader download:movie postalCode:postalCode];
    if (data != nil) {
        [data writeToFile:path atomically:YES];
        [NowPlayingAppDelegate refresh];
    }
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

    NSArray* arguments = [NSArray arrayWithObjects:moviesWithPosterLinks, moviesWithoutPosterLinks, nil];
    for (NSArray* list in arguments) {
        for (Movie* movie in list) {
            NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
            {
                [self downloadPoster:movie postalCode:postalCode];
            }
            [autoreleasePool release];
        }
    }
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    [self deleteObsoletePosters:movies];
    [self downloadPosters:movies];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}


@end