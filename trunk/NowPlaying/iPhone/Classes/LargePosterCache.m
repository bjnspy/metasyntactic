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
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
    }
    
    return self;
}


+ (LargePosterCache*) cache {
    return [[[LargePosterCache alloc] init] autorelease];
}


- (NSString*) posterFilePath:(Movie*) movie index:(NSInteger) index {
    NSString* sanitizedTitle = [FileUtilities sanitizeFileName:movie.canonicalTitle];
    sanitizedTitle = [sanitizedTitle stringByAppendingFormat:@"-%d", index];
    return [[[Application postersLargeFolder] stringByAppendingPathComponent:sanitizedTitle] stringByAppendingPathExtension:@"jpg"];
}


- (UIImage*) posterForMovie:(Movie*) movie
                      index:(NSInteger) index {
    NSString* path = [self posterFilePath:movie index:index];
    NSData* data = [FileUtilities readData:path];
    return [UIImage imageWithData:data];
}


- (UIImage*) firstPosterForMovie:(Movie*) movie {
    return [self posterForMovie:movie index:0];
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
        
        if (columns.count < 2) {
            continue;
        }
        
        NSArray* posters = [columns subarrayWithRange:NSMakeRange(1, columns.count - 1)];
        [index setObject:posters forKey:[columns objectAtIndex:0]];
    }

    if (index.count > 0) {
        [FileUtilities writeObject:index toFile:file];
        self.indexData = index;
    }
}


- (NSArray*) posterUrlsWorker:(Movie*) movie {
    [self ensureIndex];
    
    NSDictionary* index = self.index;
    
    DifferenceEngine* engine = [DifferenceEngine engine];
    NSString* title = [engine findClosestMatch:movie.canonicalTitle inArray:index.allKeys];
    
    if (title.length == 0) {
        return [NSArray array];
    }
    
    NSArray* urls = [index objectForKey:title];
    return urls;
}


- (NSArray*) posterUrls:(Movie*) movie {
    NSAssert(![NSThread isMainThread], @"");
    
    NSArray* array;
    [gate lock];
    {
        array = [self posterUrlsWorker:movie];
    }
    [gate unlock];
    return array;
}


- (void) downloadPosterForMovieWorker:(Movie*) movie
                                 urls:(NSArray*) urls
                                index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    
    NSData* data = [NetworkUtilities dataWithContentsOfAddress:[urls objectAtIndex:index]
                                                     important:NO];
    if (data != nil) {
        [FileUtilities writeData:data toFile:[self posterFilePath:movie index:index]];
        [NowPlayingAppDelegate refresh];
    }
}


- (void) downloadPosterForMovie:(Movie*) movie
                          index:(NSInteger) index {
    NSAssert(![NSThread isMainThread], @"");
    [gate lock];
    {
        NSData* data = [FileUtilities readData:[self posterFilePath:movie index:index]];
        if (data == nil) {
            NSArray* urls = [self posterUrls:movie];
            [self downloadPosterForMovieWorker:movie urls:urls index:index];
        }
    }
    [gate unlock];    
}


- (void) downloadFirstPosterForMovie:(Movie*) movie {
    [self downloadPosterForMovie:movie index:0];
}


- (NSInteger) posterCountForMovie:(Movie*) movie {
    NSAssert(![NSThread isMainThread], @"");
    NSInteger count;
    [gate lock];
    {
        NSArray* urls = [self posterUrls:movie];
        count = urls.count;
    }
    [gate unlock];
    return count;
}


@end
