// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
