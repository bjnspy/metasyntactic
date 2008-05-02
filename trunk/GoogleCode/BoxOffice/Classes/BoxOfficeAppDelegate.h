//
//  BoxOfficeAppDelegate.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationTabBarController.h"
#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"

@interface BoxOfficeAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow* window;
    IBOutlet ApplicationTabBarController* tabBarController;
    
    IBOutlet UIView* settingsView;
    
    UIApplication* application;
    BoxOfficeModel* model;
    BoxOfficeController* controller;
}

@property (nonatomic, retain) UIWindow* window;
@property (retain) UIApplication* application;
@property (retain) BoxOfficeController* controller;
@property (retain) BoxOfficeModel* model;
@property (retain) ApplicationTabBarController* tabBarController;
@property (retain) UIView* settingsView;

@end

