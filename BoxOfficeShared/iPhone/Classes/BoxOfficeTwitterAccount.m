//
//  BoxOfficeTwitterAccount.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeTwitterAccount.h"


@implementation BoxOfficeTwitterAccount

static BoxOfficeTwitterAccount* account;

+ (void) initialize {
  if (self == [BoxOfficeTwitterAccount class]) {
    account = [[BoxOfficeTwitterAccount alloc] init];
  }
}


+ (BoxOfficeTwitterAccount*) account {
  return account;
}

@end
