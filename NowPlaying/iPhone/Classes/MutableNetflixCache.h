//
//  MutableNetflixCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixCache.h"

@interface MutableNetflixCache : NetflixCache {
}


+ (MutableNetflixCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) updateQueue:(Queue*) queue
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixMoveMovieDelegate>) delegate;

- (void) updateQueue:(Queue*) queue
    byDeletingMovies:(IdentitySet*) deletedMovies
 andReorderingMovies:(IdentitySet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate;

- (void) updateQueue:(Queue*) queue 
       byAddingMovie:(Movie*) movie
            delegate:(id<NetflixAddMovieDelegate>) delegate;

- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate;

@end