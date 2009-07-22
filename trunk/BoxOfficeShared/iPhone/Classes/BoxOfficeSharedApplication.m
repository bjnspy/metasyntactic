//
//  BoxOfficeSharedApplication.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeSharedApplication.h"

#import "BoxOfficeSharedApplicationDelegate.h"

@implementation BoxOfficeSharedApplication

static id<BoxOfficeSharedApplicationDelegate> delegate = nil;

+ (void) setSharedApplicationDelegate:(id<BoxOfficeSharedApplicationDelegate>) delegate_ {
  [MetasyntacticSharedApplication setSharedApplicationDelegate:delegate_];
  delegate = delegate_;
}


+ (void) resetTabs {
  [delegate resetTabs];
}

@end
