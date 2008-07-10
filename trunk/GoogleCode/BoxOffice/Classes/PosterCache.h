//
//  PosterCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"

@class BoxOfficeModel;

@interface PosterCache : NSObject {
    NSLock* gate;
}

@property (retain) NSLock* gate;

+ (PosterCache*) cache;

- (void) update:(NSArray*) movies;

- (UIImage*) posterForMovie:(Movie*) movie;

@end
