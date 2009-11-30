//
//  NetflixUpdater.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixUpdater : AbstractCache {
@private
NSDictionary* presubmitRatings;
}


+ (NetflixUpdater*) updater;

- (void) updateQueue:(Queue*) queue
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixMoveMovieDelegate>) delegate
             account:(NetflixAccount*) account;

- (void) updateQueue:(Queue*) queue
    byDeletingMovies:(NSSet*) deletedMovies
 andReorderingMovies:(NSSet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate
             account:(NetflixAccount*) account;

- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
          withFormat:(NSString*) format
          toPosition:(NSInteger) position
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account;

- (void) updateQueue:(Queue*) queue
       byAddingMovie:(Movie*) movie
          withFormat:(NSString*) format
            delegate:(id<NetflixAddMovieDelegate>) delegate
             account:(NetflixAccount*) account;

- (void) updateQueue:(Queue*) queue
     byDeletingMovie:(Movie*) movie
            delegate:(id<NetflixModifyQueueDelegate>) delegate
             account:(NetflixAccount*) account;

- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate
                account:(NetflixAccount*) account;

- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account;
@end
