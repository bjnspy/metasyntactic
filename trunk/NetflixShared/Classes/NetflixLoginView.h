//
//  NetflixLoginView.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface NetflixLoginView : UIView {
@private
  UIViewController* controller;
  UILabel* messageLabel;
  UILabel* statusLabel;
  UIActivityIndicatorView* activityIndicator;
  UIButton* button;
}

- (id) initWithFrame:(CGRect)frame viewController:(UIViewController*) controller;

- (void) showOpenAndAuthorizeButton;
- (void) showRequestingAccessMessage;
- (void) showErrorOccurredMessage;
- (void) showSuccessMessage;

@end
