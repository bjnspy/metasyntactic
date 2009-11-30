//
//  NetflixAccountCache.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixAccountCache : AbstractCache {
@private
  // accessed from multiple threads.
  AutoreleasingMutableDictionary* accountToFeeds;
  AutoreleasingMutableDictionary* accountToFeedKeyToQueues;
}

+ (NetflixAccountCache*) cache;

- (NSArray*) feedsForAccount:(NetflixAccount*) account;

- (void) saveQueue:(Queue*) queue account:(NetflixAccount*) account;
- (void) saveFeeds:(NSArray*) feeds account:(NetflixAccount*) account;

- (Feed*) feedForKey:(NSString*) key account:(NetflixAccount*) account;

- (Queue*) queueForKey:(NSString*) key account:(NetflixAccount*) account;
- (Queue*) queueForFeed:(Feed*) feed account:(NetflixAccount*) account;

@end
