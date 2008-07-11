//
//  TrailerCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"

@interface TrailerCache : NSObject {
    NSLock* gate;
    NSDictionary* movieToTrailersMap;
}

@property (retain) NSLock* gate;
@property (retain) NSDictionary* movieToTrailersMap;

+ (TrailerCache*) cache;

- (void) update:(NSArray*) movies;

- (NSArray*) trailersForMovie:(Movie*) movie;

@end
