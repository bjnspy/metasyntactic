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

- (BOOL) knownMovie:(NSString*) posterPath
{
    for (Movie* movie in self.model.movies)
    {
        if ([[self posterFilePath:movie] isEqual:posterPath])
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
    
    for (NSString* fileName in contents)
    {
        NSString* filePath = [[Application postersFolder] stringByAppendingPathComponent:fileName];
        if (![self knownMovie:filePath])
        {
            [manager removeFileAtPath:filePath handler:nil];
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
    
    [self performSelectorInBackground:@selector(downloadPostersBackgroundEntryPoint:) withObject:moviesWithoutPosters];
}

- (void) downloadPostersBackgroundEntryPoint:(NSArray*) moviesWithoutPosters
{
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    @try
    {
        [self downloadPosters:moviesWithoutPosters];
    }
    @finally
    {
        [autoreleasePool release];
    }
}

- (void) downloadPosters:(NSArray*) moviesWithoutPosters
{
    for (Movie* movie in moviesWithoutPosters)
    {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        @try
        {
            [self downloadPoster:movie];
        }
        @finally
        {
            [autoreleasePool release];
        }
    }
}

- (void) downloadPoster:(Movie*) movie
{
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

- (BOOL) posterFileExists:(Movie*) movie
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self posterFilePath:movie]];
}

- (UIImage*) posterForMovie:(Movie*) movie
{
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

@end
