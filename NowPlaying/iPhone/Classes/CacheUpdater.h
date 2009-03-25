//
//  CacheUpdater.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface CacheUpdater : NSObject {
@private
    NSLock* searchOperationsGate;
    NSArray* searchOperations;
}

+ (CacheUpdater*) cacheUpdater;

- (void) prioritizeMovie:(Movie*) movie now:(BOOL) now;

- (void) addSearchMovies:(NSArray*) movies;

- (void) addMovie:(Movie*) movie;
- (void) addMovies:(NSArray*) movies;

@end
