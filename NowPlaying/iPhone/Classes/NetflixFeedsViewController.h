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
    NSArray* feedKeys;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                           feedKeys:(NSArray*) feedKeys;

@end
