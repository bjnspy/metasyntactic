//
//  RSSCache.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCache.h"

@interface RSSCache : AbstractCache {
@private
    NSMutableDictionary* titleToItems;
}

+ (RSSCache*) cacheWithModel:(Model*) model;

- (void) update;
- (NSArray*) itemsForTitle:(NSString*) title;

+ (NSArray*) titles;

@end
