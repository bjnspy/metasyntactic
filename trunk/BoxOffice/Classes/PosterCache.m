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
@synthesize model;

- (void) dealloc {
    self.gate = nil;
    self.model = nil;
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
        self.model = model_;
    }
    
    return self;
}

+ (PosterCache*) cacheWithModel:(BoxOfficeModel*) model {
    return [[[PosterCache alloc] initWithModel:model] autorelease];
}

- (void) update:(NSArray*) movies {
    [self.model addBackgroundTask:@"Downloading Posters"];
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
    for (Movie* movie in movies) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self downloadPoster:movie];
        
        [autoreleasePool release];
    }
}

- (void) updateInBackground:(NSArray*) movies {
    [self deleteObsoletePosters:movies];
    [self downloadPosters:movies];
}

- (void) backgroundEntryPoint:(NSArray*) movies {
    [gate lock];
    {        
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        
        [self updateInBackground:movies];
        [self performSelectorOnMainThread:@selector(onBackgroundThreadFinished:) withObject:nil waitUntilDone:NO];
        
        [autoreleasePool release];
    }
    [gate unlock];
}

- (void) onBackgroundThreadFinished:(id) object {
    if (self.model != nil) {
        [self.model removeBackgroundTask:@"Finished Downloading Posters"];
    }
}

- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

@end
