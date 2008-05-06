//
//  PosterCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"

@class BoxOfficeModel;

@interface PosterCache : NSObject {
    NSMutableDictionary* movieToPosterMap;
    NSLock* gate;
}

@property (retain) NSMutableDictionary* movieToPosterMap;
@property (retain) NSLock* gate;


+ (PosterCache*) cache;

- (void) update:(NSArray*) movies;

- (UIImage*) posterForMovie:(Movie*) movie;

@end
