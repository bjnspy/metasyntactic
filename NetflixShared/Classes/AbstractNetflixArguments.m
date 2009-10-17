//
//  AbstractNetscapeArguments.m
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractNetflixArguments.h"

@interface AbstractNetflixArguments()
@property (retain) NetflixAccount* account;
@end


@implementation AbstractNetflixArguments

@synthesize account;

- (void) dealloc {
  self.account = nil;
  [super dealloc];
}


- (id) initWithAccount:(NetflixAccount*) account_ {
  if ((self = [super init])) {
    self.account = account_;
  }
  
  return self;
}

@end
