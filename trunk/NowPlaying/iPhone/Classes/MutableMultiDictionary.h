//
//  MutableMultiDictionary.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MultiDictionary.h"

@interface MutableMultiDictionary : MultiDictionary {
@private
    NSMutableDictionary* mutableDictionary_;
}

+ (MutableMultiDictionary*) dictionary;

- (void) addObject:(id) object
            forKey:(id) key;

- (void) addObjects:(NSArray*) objects
             forKey:(id) key;

- (NSMutableArray*) mutableObjectsForKey:(id) key;

- (void) removeObjectsForKey:(id) key;

@end
