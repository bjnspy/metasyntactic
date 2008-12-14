//
//  NetflixLoginViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


@interface NetflixLoginViewController : UIViewController {
@private
    NetflixNavigationController* navigationController;
    UILabel* messageLabel;
    UILabel* statusLabel;
    UIActivityIndicatorView* activityIndicator;
    UIButton* button;
    
    OAToken* authorizationToken;
    BOOL didShowBrowser;
}

- (id) initWithNavigationController:(NetflixNavigationController*) navigationController;

@end
