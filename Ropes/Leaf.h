//
//  Leaf.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Rope.h"

@interface Leaf : Rope {
@private
  NSString* string;
  NSUInteger hash;
}

+ (Rope*) emptyLeaf;

+ (Rope*) createLeaf:(NSString*) value;

@end
