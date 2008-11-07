//
//  BlurayCache.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractDVDBlurayCache.h"

@interface BlurayCache : AbstractDVDBlurayCache {
}

+ (BlurayCache*) cacheWithModel:(NowPlayingModel*) model;

@end