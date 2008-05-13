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
    BoxOfficeModel* model;
    NSLock* gate;
}

@property (assign) BoxOfficeModel* model;
@property (retain) NSLock* gate;

+ (PosterCache*) cacheWithModel:(BoxOfficeModel*) model;

- (void) update:(NSArray*) movies;

- (UIImage*) posterForMovie:(Movie*) movie;

@end
