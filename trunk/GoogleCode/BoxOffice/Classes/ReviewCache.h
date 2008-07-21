//
//  ReviewCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReviewCache : NSObject {
    NSLock* gate;
    
    // movieId -> { Date, [Reviews] }
    NSMutableDictionary* movieToReviewMap;
}

@property (retain) NSLock* gate;
@property (retain) NSMutableDictionary* movieToReviewMap;

+ (ReviewCache*) cache;

- (void) update:(NSDictionary*) supplementaryInformation;

- (NSArray*) reviewsForMovie:(NSString*) movieTitle;

- (void) applicationWillTerminate;

@end
