//
//  AbstractNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"

@class ApplicationTabBarController;

@interface AbstractNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
}

@property (assign) ApplicationTabBarController* tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (BoxOfficeModel*) model;

@end
