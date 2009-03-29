//
//  MutablePointerSet.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PointerSet.h"

@interface MutablePointerSet : PointerSet {
@private
    NSMutableSet* mutableSet;
}

@property (readonly, retain) NSMutableSet* mutableSet;

+ (MutablePointerSet*) set;

- (void) addObject:(id) object;
- (void) removeObject:(id) object;

@end
