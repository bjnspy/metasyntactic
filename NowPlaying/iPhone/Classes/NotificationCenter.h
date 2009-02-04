//
//  NotificationCenter.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 2/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NotificationCenter : NSObject {
@private
    UIView* view;
    UILabel* background;
    UILabel* notificationLabel;
    UILabel* blackLabel;
}

+ (NotificationCenter*) centerWithView:(UIView*) view;

- (void) addToView;

- (void) willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation;
- (void) didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;

@end
