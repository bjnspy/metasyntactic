//
//  AbstractCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

#import "ThreadingUtilities.h"

@interface AbstractCache()
@property (retain) NSLock* gate;
@end


@implementation AbstractCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


- (void) clearStaleData {
    [ThreadingUtilities performSelector:@selector(clearStaleDataBackgroundEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:gate
                                visible:NO];
}


- (void) clearStaleDataBackgroundEntryPoint {
    @throw [NSException exceptionWithName:@"Improper Subclassing" reason:@"" userInfo:nil];
}


@end
