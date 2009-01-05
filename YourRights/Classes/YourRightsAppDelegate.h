//
//  YourRightsAppDelegate.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface YourRightsAppDelegate : NSObject <UIApplicationDelegate> {
@private
    UIWindow *window;
    YourRightsNavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

