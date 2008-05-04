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

@synthesize model;
@synthesize movieToPosterMap;

- (id) initWithModel:(BoxOfficeModel*) model_
{
    if (self = [super init])
    {
        self.model = model_;
        self.movieToPosterMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) dealloc
{
    self.model = nil;
    self.movieToPosterMap = nil;
    [super dealloc];
}

- (void) update
{
    [self deleteObsoletePosters];
    [self enqueueRequests];
}

- (BOOL) knownMovie:(NSString*) movieTitle
{
    for (Movie* movie in self.model.movies)
    {
        if ([movie.title isEqual:movieTitle])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void) deleteObsoletePosters
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray* contents = [manager directoryContentsAtPath:[Application postersFolder]];
    
    for (NSString* filePath in contents)
    {
        NSString* movieTitle = [filePath stringByDeletingPathExtension];
        if (![self knownMovie:movieTitle])
        {
            [manager removeFileAtPath:movieTitle handler:nil];
        }
    }
}

- (void) enqueueRequests
{
    NSMutableArray* moviesWithoutPosters = [NSMutableArray array];
    
    for (Movie* movie in model.movies)
    {
        if ([self posterFileExists:movie])
        {
            NSLog(@"PosterCache:enqueueRequests: Already have a poster for %@", movie.title);
            continue;
        }
        
        [moviesWithoutPosters addObject:movie];
    }
    
    [self performSelectorInBackground:@selector(getPostersBackgroundEntryPoint:) withObject:moviesWithoutPosters];
}

- (void) getPostersBackgroundEntryPoint:(NSArray*) moviesWithoutPosters
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self getPosters:moviesWithoutPosters];
    
    [autoreleasePool release];
}

- (void) getPosters:(NSArray*) moviesWithoutPosters
{
    for (Movie* movie in moviesWithoutPosters)
    {
        [self getPoster:movie];
    }
}

- (void) setPosterForMovie:(NSArray*) array
{
    [self.movieToPosterMap setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
}

- (void) getPoster:(Movie*) movie
{
    NSData* data = [PosterDownloader download:movie];
    //[date wri
    NSString* path = [self posterFilePath:movie];
    NSString* tempPath = [path stringByAppendingPathExtension:@"temp"];
    NSError* error;
    BOOL result1 = [[NSFileManager defaultManager] createFileAtPath:tempPath contents:data attributes:nil];
    BOOL result2 = [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:path error:&error];
    //[data writeToFile:path atomically:YES];
    //NSError* error;
    //BOOL result = [data writeToFile:path options:NSAtomicWrite error:&error];
    NSLog(@"%@ %d %d", error, result1, result2);
}

- (NSString*) posterFilePath:(Movie*) movie
{
   return [[[Application postersFolder] stringByAppendingPathComponent:movie.title]
                                         stringByAppendingPathExtension:@"image"];
}

- (BOOL) posterFileExists:(Movie*) movie
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self posterFilePath:movie]];
}

- (UIImage*) posterForMovie:(Movie*) movie
{
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
    //return [UIImage imageWithContentsOfFile:[self posterFilePath:movie]];
}

@end
