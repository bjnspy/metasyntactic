//
//  RSSCache.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface RSSCache : AbstractCache {

}

+ (RSSCache*) cacheWithModel:(Model*) model;

- (void) update;

+ (NSArray*) titles;

@end
