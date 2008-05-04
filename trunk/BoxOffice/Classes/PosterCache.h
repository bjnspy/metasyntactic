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
    NSMutableDictionary* movieToPosterMap;
}

@property (assign) BoxOfficeModel* model;
@property (retain) NSMutableDictionary* movieToPosterMap;

- (id) initWithModel:(BoxOfficeModel*) model;
- (void) dealloc;

- (void) update;

- (void) deleteObsoletePosters;
- (void) enqueueRequests;

- (NSString*) posterFilePath:(Movie*) movie;
- (BOOL) posterFileExists:(Movie*) movie;

- (void) downloadPosters:(NSArray*) moviesWithoutPosters;
- (void) downloadPoster:(Movie*) movie;

- (UIImage*) posterForMovie:(Movie*) movie;

@end
