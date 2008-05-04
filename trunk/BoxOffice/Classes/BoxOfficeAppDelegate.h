//
//  BoxOfficeAppDelegate.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#import "ApplicationTabBarController.h"
#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"

@interface BoxOfficeAppDelegate : NSObject <UIApplicationDelegate> {
    sqlite3* database;

	IBOutlet UIWindow* window;
    IBOutlet ApplicationTabBarController* tabBarController;
    
    UIApplication* application;
    BoxOfficeModel* model;
    BoxOfficeController* controller;
}

@property (nonatomic, retain) UIWindow* window;
@property (retain) UIApplication* application;
@property (retain) BoxOfficeController* controller;
@property (retain) BoxOfficeModel* model;
@property (retain) ApplicationTabBarController* tabBarController;

@end

