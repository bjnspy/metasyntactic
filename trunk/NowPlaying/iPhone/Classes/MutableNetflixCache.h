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

#import "NetflixCache.h"

@interface MutableNetflixCache : NetflixCache {
}


+ (MutableNetflixCache*) cacheWithModel:(Model*) model;

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