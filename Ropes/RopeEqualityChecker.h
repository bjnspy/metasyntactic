//
//  RopeEqualityChecker.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RopeEqualityChecker : NSObject {
@private
  Rope* rope1;
  Rope* rope2;
  
  Iterator* i1;
  Iterator* i2;
  
  Leaf* leaf1;
  Leaf* leaf2;
  
  NSInteger leaf1Start;
  NSInteger leaf1End;
  NSInteger leaf2Start;
  NSInteger leaf2End;
}

+ (RopeEqualityChecker*) createWithRope1:(Rope*) rope1 rope2:(Rope*) rope2;

- (BOOL) check;

@end
