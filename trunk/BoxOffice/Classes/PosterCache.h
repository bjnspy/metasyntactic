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
    NSThread* backgroundThread;
}

@property (assign) BoxOfficeModel* model;

- (id) initWithModel:(BoxOfficeModel*) model;
- (void) dealloc;

- (void) update;

- (void) deleteObsoletePosters;
- (void) enqueueRequests;

- (NSString*) posterFilePath:(Movie*) movie;
- (BOOL) posterFileExists:(Movie*) movie;

- (void) getPosters:(NSArray*) moviesWithoutPosters;
- (void) getPoster:(Movie*) movie;

@end
