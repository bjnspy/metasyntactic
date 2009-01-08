//
//  iPhoneSharedAppDelegate.h
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 1/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPhoneSharedAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

