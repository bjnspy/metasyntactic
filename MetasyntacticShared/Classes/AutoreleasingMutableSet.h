//
//  AutoreleasingMutableSet.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AutoreleasingMutableSet : NSMutableSet {
@private
  NSMutableSet* underlyingSet;
}

+ (AutoreleasingMutableSet*) set;
+ (AutoreleasingMutableSet*) setWithArray:(NSArray*) array;
+ (AutoreleasingMutableSet*) setWithSet:(NSSet*) set;

@end
