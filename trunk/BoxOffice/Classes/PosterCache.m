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

- (id) initWithModel:(BoxOfficeModel*) model_
{
    if (self = [super init])
    {
        self.model = model_;
    }
    
    return self;
}

- (void) dealloc
{
    self.model = nil;
    [super dealloc];
}

- (void) update
{
    [self deleteObsoletePosters];
    [self enqueueRequests];
}

- (void) deleteObsoletePosters
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray* contents = [manager directoryContentsAtPath:[Application postersFolder]];
    
    for (NSString* filePath in contents)
    {
        
    }
}

- (void) enqueueRequests
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
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

- (void) getPoster:(Movie*) movie
{
    NSData* data = [PosterDownloader download:movie];
    if (data != nil)
    {
        [data writeToFile:[self posterFilePath:movie] atomically:YES];
    }
}

- (NSString*) posterFilePath:(Movie*) movie
{
    return nil;
}

- (BOOL) posterFileExists:(Movie*) movie
{
    return NO;
}

@end
