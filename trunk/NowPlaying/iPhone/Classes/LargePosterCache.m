//
//  LargePosterCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LargePosterCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "Movie.h"

@implementation LargePosterCache

@synthesize gate;
@synthesize indexData;

- (void) dealloc {
    self.gate = nil;
    self.indexData = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}


+ (LargePosterCache*) cache {
    return [[[LargePosterCache alloc] init] autorelease];
}


- (NSString*) posterFilePath:(Movie*) movie {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    return [[[Application postersLargeFolder] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    NSString* path = [self posterFilePath:movie];
    NSData* data = [FileUtilities readData:path];
    return [UIImage imageWithData:data];
}


- (NSString*) indexFile {
    return [[Application postersLargeFolder] stringByAppendingPathComponent:@"Index.plist"];
}


- (NSDictionary*) loadIndex {
    NSDictionary* result = [FileUtilities readObject:self.indexFile];
    if (result == nil) {
        return [NSDictionary dictionary];
    }
    
    return result;
}


- (NSDictionary*) index {
    if (indexData == nil) {
        self.indexData = [self loadIndex];
    }
    
    return indexData;
}


- (void) ensureIndex {
    NSString* file = self.indexFile;
    NSDate* modificationDate = [FileUtilities modificationDate:file];
    if (modificationDate != nil) {
        if (ABS([modificationDate timeIntervalSinceNow]) < ONE_WEEK) {
            return;
        }
    }
    
    NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupPosterListings?provider=imp", [Application host]];
    NSString* result = [NetworkUtilities stringWithContentsOfAddress:address
                                                           important:NO];
    if (result.length == 0) {
        return;
    }
    
    NSMutableDictionary* index = [NSMutableDictionary dictionary];
    for (NSString* row in [result componentsSeparatedByString:@"\n"]) {
        NSArray* columns = [row componentsSeparatedByString:@"\t"];
        
        if (columns.count != 2) {
            continue;
        }
        
        [index setObject:[columns objectAtIndex:1] forKey:[columns objectAtIndex:0]];
    }

    if (index.count > 0) {
        [FileUtilities writeObject:index toFile:file];
        self.indexData = index;
    }
}


- (void) downloadPosterForMovieWorker:(Movie*) movie {
    [self ensureIndex];
    
    NSDictionary* index = self.index;
    
    DifferenceEngine* engine = [DifferenceEngine engine];
    NSString* title = [engine findClosestMatch:movie.canonicalTitle inArray:index.allKeys];
    
    if (title.length == 0) {
        return;
    }
    
    NSString* url = [index objectForKey:title];
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:url
                                                     important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:[self posterFilePath:movie]];
        [NowPlayingAppDelegate refresh];
    }
}


- (void) downloadPosterForMovie:(Movie*) movie {
    [gate lock];
    {
        NSData* data = [FileUtilities readData:[self posterFilePath:movie]];
        if (data == nil) {
            [self downloadPosterForMovieWorker:movie];
        }
    }
    [gate unlock];
}


- (NSInteger) posterCountWorker:(Movie*) movie {
    return 0;
}


- (NSInteger) posterCount:(Movie*) movie {
    NSInteger count;
    [gate lock];
    {
        count = [self posterCountWorker:movie];
    }
    [gate unlock];
    return count;
}

@end
