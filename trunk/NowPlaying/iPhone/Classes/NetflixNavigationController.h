//
//  NetflixNavigationController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractNavigationController.h"

@interface NetflixNavigationController : AbstractNavigationController {
@private
    NetflixViewController* netflixViewController;
}

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

@end
