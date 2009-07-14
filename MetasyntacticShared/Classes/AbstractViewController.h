//
//  AbstractViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractViewController : UIViewController {
@private
  BOOL pushed;
}

/* @protected */
- (void) onBeforeViewControllerPushed;
- (void) onAfterViewControllerPushed;
- (void) onBeforeViewControllerPopped;
- (void) onAfterViewControllerPopped;

@end
