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

#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "PosterDownloader.h"
#import "Utilities.h"

@implementation PosterCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (PosterCache*) cache {
    return [[[PosterCache alloc] init] autorelease];
}


- (void) update:(NSArray*) movies {
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:movies]];
}


- (NSString*) posterFilePath:(Movie*) movie {
    NSString* sanitizedTitle = [Application sanitizeFileName:movie.canonicalTitle];
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


- (void) downloadPoster:(Movie*) movie {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self posterFilePath:movie]]) {
        return;
    }

    NSData* data = [PosterDownloader download:movie];
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

    NSArray* arguments = [NSArray arrayWithObjects:moviesWithPosterLinks, moviesWithoutPosterLinks, nil];
    for (NSArray* list in arguments) {
        for (Movie* movie in list) {
            NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

            [self downloadPoster:movie];

            [autoreleasePool release];
        }
    }
}


- (void) updateInBackground:(NSArray*) movies {
    [self deleteObsoletePosters:movies];
    [self downloadPosters:movies];
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    [gate lock];
    [GlobalActivityIndicator addBackgroundTask:NO];
    {
        [NSThread setThreadPriority:0.0];

        [self updateInBackground:movies];
    }
    [GlobalActivityIndicator removeBackgroundTask:NO];
    [gate unlock];
    [autoreleasePool release];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}


@end