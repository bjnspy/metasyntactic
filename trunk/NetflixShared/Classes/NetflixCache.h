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

#import "AbstractMovieCache.h"

@interface NetflixCache : AbstractMovieCache {
@private
  // accessed from multiple threads.  Always access through property.
  AutoreleasingMutableDictionary* accountToFeeds;
  AutoreleasingMutableDictionary* accountToFeedKeyToQueues;
}

+ (NSString*) noInformationFound;

- (void) update:(BOOL) force;

- (NSArray*) feedsForAccount:(NetflixAccount*) account;
- (Feed*) feedForKey:(NSString*) key account:(NetflixAccount*) account;
- (Queue*) queueForFeed:(Feed*) feed account:(NetflixAccount*) account;
- (Queue*) queueForKey:(NSString*) key account:(NetflixAccount*) account;
- (NSString*) titleForKey:(NSString*) key account:(NetflixAccount*) account;
- (NSString*) titleForKey:(NSString*) key includeCount:(BOOL) includeCount account:(NetflixAccount*) account;

- (Movie*) correspondingNetflixMovie:(Movie*) movie;

- (NSArray*) statusesForMovie:(Movie*) movie account:(NetflixAccount*) account;

- (NSString*) userRatingForMovie:(Movie*) movie account:(NetflixAccount*) account;
- (NSString*) netflixRatingForMovie:(Movie*) movie account:(NetflixAccount*) account;
- (NSString*) availabilityForMovie:(Movie*) movie;

- (NSArray*) castForMovie:(Movie*) movie;
- (NSArray*) directorsForMovie:(Movie*) movie;
- (NSString*) netflixAddressForMovie:(Movie*) movie;
- (NSString*) synopsisForMovie:(Movie*) movie;

- (BOOL) isInstantWatch:(Movie*) movie;
- (BOOL) isDvd:(Movie*) movie;
- (BOOL) isBluray:(Movie*) movie;

- (BOOL) user:(NetflixUser*) user canRentMovie:(Movie*) movie;

// Searching
- (NSArray*) movieSearch:(NSString*) query account:(NetflixAccount*) account error:(NSString**) error;

@end
