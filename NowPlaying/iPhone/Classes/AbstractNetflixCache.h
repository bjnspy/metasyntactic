//
//  AbstractNetflixCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface AbstractNetflixCache : AbstractCache {
}

+ (NSString*) dvdQueueKey;
+ (NSString*) instantQueueKey;
+ (NSString*) atHomeKey;
+ (NSString*) recommendationKey;
+ (NSString*) rentalHistoryKey;
+ (NSString*) rentalHistoryWatchedKey;
+ (NSString*) rentalHistoryReturnedKey;

- (id) initWithModel:(NowPlayingModel*) model;

// @protected
- (OAMutableURLRequest*) createURLRequest:(NSString*) address;

@end
