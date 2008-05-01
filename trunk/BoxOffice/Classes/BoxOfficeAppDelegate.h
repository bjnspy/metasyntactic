//
//  BoxOfficeAppDelegate.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationTabBarController.h"

@interface BoxOfficeAppDelegate : NSObject <UIApplicationDelegate,UITableViewDataSource,UITableViewDelegate> {
	IBOutlet UIWindow* window;
    IBOutlet ApplicationTabBarController* tabBarController;
    
    IBOutlet UIView* settingsView;
    
    UIApplication* application;
}

@property (nonatomic, retain) UIWindow* window;
@property (retain) UIApplication* application;

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section;

- (UITableViewCell*) tableView:(UITableView*) tableView 
         cellForRowAtIndexPath:(NSIndexPath*) indexPath;
@end

