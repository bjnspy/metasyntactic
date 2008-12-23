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

#import "AbstractCache.h"

@interface NetflixCache : AbstractCache {
@private
    NSArray* feedsData;
    NSMutableDictionary* queues;

    // movies whose details we want to update
    LinkedSet* normalMovies;
    LinkedSet* searchMovies;
    LinkedSet* prioritizedMovies;

    NSCondition* updateDetailsLock;
}

+ (NetflixCache*) cacheWithModel:(NowPlayingModel*) model;

+ (NSString*) dvdQueueKey;
+ (NSString*) instantQueueKey;
+ (NSString*) atHomeKey;
+ (NSString*) recommendationKey;
+ (NSString*) rentalHistoryKey;
+ (NSString*) rentalHistoryWatchedKey;
+ (NSString*) rentalHistoryReturnedKey;

- (NSArray*) search:(NSString*) query;
- (void) prioritizeMovie:(Movie*) movie;

- (BOOL) isEnqueued:(Movie*) movie;

- (void) update;

- (NSArray*) feeds;
- (Queue*) queueForFeed:(Feed*) feed;
- (Feed*) feedForKey:(NSString*) key;
- (Queue*) queueForKey:(NSString*) key;
- (NSString*) titleForKey:(NSString*) key;
- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount;

- (UIImage*) posterForMovie:(Movie*) movie;
- (UIImage*) smallPosterForMovie:(Movie*) movie;
- (NSArray*) castForMovie:(Movie*) movie;
- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSString*) imdbAddressForMovie:(Movie*) movie;
- (NSString*) synopsisForMovie:(Movie*) movie;
- (NSString*) netflixRatingForMovie:(Movie*) movie;
- (NSString*) userRatingForMovie:(Movie*) movie;

- (NSString*) noInformationFound;

- (void) updateQueue:(Queue*) queue
            fromFeed:(Feed*) feed
  byMovingMovieToTop:(Movie*) movie
            delegate:(id<NetflixModifyQueueDelegate>) delegate;

- (void) updateQueue:(Queue*) queue
            fromFeed:(Feed*) feed
    byDeletingMovies:(IdentitySet*) deletedMovies
 andReorderingMovies:(IdentitySet*) reorderedMovies
                  to:(NSArray*) movies
            delegate:(id<NetflixModifyQueueDelegate>) delegate;

- (void) changeRatingTo:(NSString*) rating
               forMovie:(Movie*) movie
               delegate:(id<NetflixChangeRatingDelegate>) delegate;

// @internal
- (OAMutableURLRequest*) createURLRequest:(NSString*) address;
- (void) processMovieItemList:(XmlElement*) element
                       movies:(NSMutableArray*) movies
                        saved:(NSMutableArray*) saved;

@end