//
//  NetflixSearchCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface NetflixSearchCache : AbstractCache {
@private
}

+ (NetflixSearchCache*) cacheWithModel:(NowPlayingModel*) model;

- (void) updateMovies:(NSArray*) movies;
- (void) updateMovie:(Movie*) movie;

- (Movie*) netflixMovieForMovie:(Movie*) movie;

@end
