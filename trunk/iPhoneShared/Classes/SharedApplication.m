//
//  SharedApplication.m
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 5/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedApplication.h"

#import "SharedApplicationDelegate.h"

@implementation SharedApplication

static id<SharedApplicationDelegate> delegate = nil;

+ (void) setSharedApplicationDelegate:(id<SharedApplicationDelegate>) delegate_ {
  delegate = delegate_;
}


+ (NSString*) localizedString:(NSString*) key {
  return [delegate localizedString:key];
}


+ (void) saveNavigationStack:(UINavigationController*) controller {
  [delegate saveNavigationStack:controller];
}


+ (BOOL) notificationsEnabled {
  return [delegate notificationsEnabled];
}

@end
