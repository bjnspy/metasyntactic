//
//  ViewControllerState.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ViewControllerState : NSObject {
@private
  BOOL onBeforeViewControllerPushedCalled;
  BOOL onAfterViewControllerPushedCalled;
  
  MPMoviePlayerController* moviePlayer;
}

- (void) viewController:(UIViewController*) controller willAppear:(BOOL) animated;
- (void) viewController:(UIViewController*) controller didAppear:(BOOL) animated;
- (void) viewController:(UIViewController*) controller willDisappear:(BOOL) animated;
- (void) viewController:(UIViewController*) controller didDisappear:(BOOL) animated;

- (void) playMovie:(NSString *)address;

@end
