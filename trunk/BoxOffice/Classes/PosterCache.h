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

- (id) init;
- (void) dealloc;

- (void) update:(NSArray*) movies;
- (void) updateInBackground:(NSArray*) movies;

- (void) deleteObsoletePosters:(NSArray*) movies;

- (void) downloadPosters:(NSArray*) movies;
- (void) downloadPoster:(Movie*) movie;

- (NSString*) posterFilePath:(Movie*) movie;

- (UIImage*) posterForMovie:(Movie*) movie;

@end
