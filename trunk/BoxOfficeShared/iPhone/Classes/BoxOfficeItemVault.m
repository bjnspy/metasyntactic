//
//  BoxOfficeItemVault.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeItemVault.h"


@implementation BoxOfficeItemVault

static BoxOfficeItemVault* vault;

+ (void) initialize {
  if (self == [BoxOfficeItemVault class]) {
    vault = [[BoxOfficeItemVault alloc] init];
  }
}


+ (BoxOfficeItemVault*) vault {
  return vault;
}

@end
