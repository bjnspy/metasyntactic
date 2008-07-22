//
//  ReviewCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoxOfficeModel;

@interface ReviewCache : NSObject {
    BoxOfficeModel* model;
    NSLock* gate;
    
    // movieId -> { Date, [Reviews] }
    NSMutableDictionary* movieToReviewMap;
}

@property (assign) BoxOfficeModel* model;
@property (retain) NSLock* gate;
@property (retain) NSMutableDictionary* movieToReviewMap;

+ (ReviewCache*) cacheWithModel:(BoxOfficeModel*) model;

- (void) clear;
- (void) update:(NSDictionary*) supplementaryInformation ratingsProvider:(NSInteger) ratingsProvider;

- (NSArray*) reviewsForMovie:(NSString*) movieTitle;

- (void) applicationWillTerminate;

@end
