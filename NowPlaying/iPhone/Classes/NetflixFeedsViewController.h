//
//  NetflixFeedsViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface NetflixFeedsViewController : UITableViewController {
@private
    AbstractNavigationController* navigationController;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController;

@end
