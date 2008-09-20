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

#import "PosterCache.h"

#import "AddressLocationCache.h"
#import "Application.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "Location.h"
#import "Movie.h"
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
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self posterFilePath:movie]]) {
        return;
    }

    NSData* data = [PosterDownloader download:movie postalCode:postalCode];
    NSString* path = [self posterFilePath:movie];
    [data writeToFile:path atomically:YES];
}


- (void) downloadPosters:(NSArray*) movies {
    // movies with poster links download faster. try them first.
    NSMutableArray* moviesWithPosterLinks = [NSMutableArray array];
    NSMutableArray* moviesWithoutPosterLinks = [NSMutableArray array];

    for (Movie* movie in movies) {
        if ([Utilities isNilOrEmpty:movie.poster]) {
            [moviesWithoutPosterLinks addObject:movie];
        } else {
            [moviesWithPosterLinks addObject:movie];
        }
    }
    
    Location* location = [model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:model.userAddress];
    NSString* postalCode = location.postalCode;
    if (postalCode == nil) {
        postalCode = @"10009";
    }

    NSArray* arguments = [NSArray arrayWithObjects:moviesWithPosterLinks, moviesWithoutPosterLinks, nil];
    for (NSArray* list in arguments) {
        for (Movie* movie in list) {
            NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

            [self downloadPoster:movie postalCode:postalCode];

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