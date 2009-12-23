//
//  BoxOfficeVault.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeVault.h"


@implementation BoxOfficeVault

static BoxOfficeVault* vault;

+ (void) initialize {
  if (self == [BoxOfficeVault class]) {
    vault = [[BoxOfficeVault alloc] init];
  }
}

+ (BoxOfficeVault*) vault {
  return vault;
}

@end
