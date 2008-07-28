//
//  BoxOfficeAppDelegate.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright Metasyntactic 2008. All rights reserved.
//

#import "ApplicationTabBarController.h"
#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"
#import "NotificationCenter.h"

@interface BoxOfficeAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow* window;
    IBOutlet ApplicationTabBarController* tabBarController;
    NotificationCenter* notificationCenter;

    BoxOfficeModel* model;
    BoxOfficeController* controller;
}

@property (nonatomic, retain) UIWindow* window;
@property (retain) BoxOfficeController* controller;
@property (retain) BoxOfficeModel* model;
@property (retain) ApplicationTabBarController* tabBarController;
@property (retain) NotificationCenter* notificationCenter;

@end

