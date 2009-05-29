//
//  SharedApplicationDelegate.h
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 5/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol SharedApplicationDelegate
- (NSString*) localizedString:(NSString*) key;
- (void) saveNavigationStack:(UINavigationController*) controller;
- (BOOL) notificationsEnabled;
@end