// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
