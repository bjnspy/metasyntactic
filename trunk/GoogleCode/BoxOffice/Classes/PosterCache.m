//
//  PosterCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "PosterCache.h"
#import "Application.h"
#import "BoxOfficeModel.h"
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
    NSString* sanitizedTitle = [movie.title stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"];
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
        NSError* error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
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
    // movies with poster links download faster.  try them first.
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
    {
        [NSThread setThreadPriority:0.0];

        [self updateInBackground:movies];
    }
    [gate unlock];
    [autoreleasePool release];
}

- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

@end
