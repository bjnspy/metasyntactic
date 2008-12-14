//
//  NetflixViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface NetflixViewController : UITableViewController<UIAlertViewDelegate> {
@private 
    NetflixNavigationController* navigationController;
}

- (id) initWithNavigationController:(NetflixNavigationController*) navigationController;

@end
