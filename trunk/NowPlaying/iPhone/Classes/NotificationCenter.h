//
//  NotificationCenter.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NotificationCenter : NSObject {
@private
    UIWindow* window;
    UILabel* background;
    UILabel* notificationLabel;
    UILabel* blackLabel;
}

+ (NotificationCenter*) centerWithWindow:(UIWindow*) window;

- (void) addToWindow;
- (void) showNotification:(NSString*) message;
- (void) hideNotification;

- (void) willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation;
- (void) didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;

@end
