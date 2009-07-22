//
//  BoxOfficeAppDelegate.h
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeSharedApplicationDelegate.h"

@interface AbstractBoxOfficeAppDelegate : NSObject<BoxOfficeSharedApplicationDelegate,SplashScreenDelegate> {
@private
  UIViewController* viewController;
}

@end
