//
//  NetflixCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "Movie.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"

@interface NetflixCache()
@property (retain) NSArray* queueData;
@end


@implementation NetflixCache

@synthesize queueData;

- (void) dealloc {
    self.queueData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
}


+ (NetflixCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[NetflixCache alloc] initWithModel:model] autorelease];
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSSet set];
}


- (NSString*) queueFile {
    return [[Application netflixDirectory] stringByAppendingPathComponent:@"Queue.plist"];
}


- (NSArray*) loadQueue {
    NSArray* array = [FileUtilities readObject:self.queueFile];
    if (array.count == 0) {
        return [NSArray array];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
    }
    return result;
}


- (NSArray*) queue {
    if (queueData == nil) {
        self.queueData = [self loadQueue];
    }
    
    return queueData;
}


- (void) clear {
    [Application resetNetflixDirectories];
    self.queueData = nil;
    
    [NowPlayingAppDelegate majorRefresh:YES];
}


- (void) update {
    if (model.netflixUserId.length == 0) {
        [self clear];
        return;
    }
        
    [ThreadingUtilities performSelector:@selector(updateBackgroundEntryPoint)
                               onTarget:self
                   inBackgroundWithGate:gate
                                visible:YES];
}


- (void) downloadQueue {
    
}


- (void) updateBackgroundEntryPoint {
    if (model.netflixUserId.length == 0) {
        return;
    }
    
    [self downloadQueue];
}

@end