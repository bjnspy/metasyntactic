//
//  AmazonCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface AmazonCache : AbstractCache {
@private
    LinkedSet* prioritizedMovies;
    LinkedSet* normalMovies;
}

+ (AmazonCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) update:(NSArray*) movies;
- (void) updateMovie:(Movie*) movie;
- (void) prioritizeMovie:(Movie*) movie;

- (NSString*) amazonAddressForMovie:(Movie*) movie;

@end
