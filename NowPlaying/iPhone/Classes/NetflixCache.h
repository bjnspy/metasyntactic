//
//  NetflixCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface NetflixCache : AbstractCache {
@private
    NSArray* feedsData;
    NSMutableDictionary* queues;
}

+ (NetflixCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) update;
- (NSArray*) feeds;
- (Queue*) queueForFeed:(Feed*) feed;

- (NSString*) noInformationFound;

- (void) moveMovie:(Movie*) movie 
      toTopOfQueue:(Queue*) queue
          fromFeed:(Feed*) feed
          delegate:(id<NetflixReorderQueueDelegate>) delegate;

@end
