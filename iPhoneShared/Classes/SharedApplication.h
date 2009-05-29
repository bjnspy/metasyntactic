//
//  SharedApplication.h
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 5/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SharedApplicationDelegate.h"

@interface SharedApplication : NSObject {

}

+ (void) setSharedApplicationDelegate:(id<SharedApplicationDelegate>) delegate;

+ (NSString*) localizedString:(NSString*) key;

+ (void) saveNavigationStack:(UINavigationController*) controller;

+ (BOOL) notificationsEnabled;

@end
