//
//  IdentitySet.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface IdentitySet : NSObject {
@private
    NSMutableSet* set;
}

+ (IdentitySet*) set;
+ (IdentitySet*) setWithArray:(NSArray*) values;

- (void) addObject:(id) value;
- (void) addObjectsFromArray:(NSArray*) values;
- (BOOL) containsObject:(id) value;
- (void) removeObject:(id) value;

- (NSInteger) count;

- (NSArray*) allObjects;

@end
