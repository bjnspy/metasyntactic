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
    NSArray* queueData;
}

+ (NetflixCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) update;
- (NSArray*) queue;

@end
