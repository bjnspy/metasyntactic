//
//  Concatenation.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Rope.h"

@interface Concatenation : Rope {
@private
  Rope* left;
  Rope* right;
  NSInteger length;
  uint8_t depth;
  NSUInteger hash;
}

@property (readonly) NSInteger length;
@property (readonly) uint8_t depth;

+ (Rope*) createWithLeft:(Rope*) left right:(Rope*) right;

@end
