//
//  WikipediaCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface WikipediaCache : AbstractCache {
@private
    LinkedSet* prioritizedMovies;
}

+ (WikipediaCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) update:(NSArray*) movies;
- (void) prioritizeMovie:(Movie*) movie;

- (NSString*) wikipediaAddressForMovie:(Movie*) movie;

@end
