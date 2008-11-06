//
//  LargePosterCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface LargePosterCache : NSObject {
    NSLock* gate;
    NSDictionary* indexData;
}

@property (retain) NSLock* gate;
@property (retain) NSDictionary* indexData;

+ (LargePosterCache*) cache;

- (UIImage*) firstPosterForMovie:(Movie*) movie;
- (UIImage*) posterForMovie:(Movie*) movie index:(NSInteger) index;

- (void) downloadFirstPosterForMovie:(Movie*) movie;
- (void) downloadAllPostersForMovie:(Movie*) movie;
- (NSInteger) posterCountForMovie:(Movie*) movie;

@end
