//
//  PosterCache.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterCache.h"
#import "Application.h"
#import "BoxOfficeModel.h"
#import "Movie.h"
#import "PosterDownloader.h"

@implementation PosterCache

@synthesize gate;
@synthesize movieToPosterMap;

+ (PosterCache*) cache
{
    return [[[PosterCache alloc] init] autorelease];
}

- (id) init
{
    if (self = [super init])
    {
        self.movieToPosterMap = [NSMutableDictionary dictionary];
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    self.movieToPosterMap = nil;
    self.gate = nil;
    [super dealloc];
}

- (void) update:(NSArray*) movies
{
    [self performSelectorInBackground:@selector(backgroundEntryPoint:)
                           withObject:[NSArray arrayWithArray:movies]];
}

- (void) backgroundEntryPoint:(NSArray*) movies
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self updateInBackground:movies];
    
    [autoreleasePool release];
}

- (void) updateInBackground:(NSArray*) movies
{
    [gate lock];
    {
        [self deleteObsoletePosters:movies];
        [self downloadPosters:movies];
    }
    [gate unlock];
}

- (void) deleteObsoletePosters:(NSArray*) movies
{
    NSMutableSet* set = [NSMutableSet set];
    NSArray* contents = [[NSFileManager defaultManager] directoryContentsAtPath:[Application postersFolder]];
    for (NSString* fileName in contents)
    {
        NSString* filePath = [[Application postersFolder] stringByAppendingPathComponent:fileName];
        [set addObject:filePath];
    }
    
    for (Movie* movie in movies)
    {
        [set removeObject:[self posterFilePath:movie]];
    }
    
    for (NSString* filePath in set)
    {
        [[NSFileManager defaultManager] removeFileAtPath:filePath handler:nil];
    }
}

- (void) downloadPosters:(NSArray*) moviesWithoutPosters
{
    for (Movie* movie in moviesWithoutPosters)
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadPoster:movie];
        
        [autoreleasePool release];
    }
}

- (void) downloadPoster:(Movie*) movie
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self posterFilePath:movie]])
    {
        // already have the poster.  Don't need to do anything.
        return;
    }
    
    NSData* data = [PosterDownloader download:movie];
    NSString* path = [self posterFilePath:movie];
    [data writeToFile:path atomically:YES];
}

- (NSString*) posterFilePath:(Movie*) movie
{
    NSString* sanitizedTitle = [movie.title stringByReplacingOccurrencesOfString:@"/" withString:@"-slash-"];
    return [[[Application postersFolder] stringByAppendingPathComponent:sanitizedTitle]
                                         stringByAppendingPathExtension:@"jpg"];
}

- (UIImage*) posterForMovie:(Movie*) movie
{
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

@end
