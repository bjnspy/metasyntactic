//
//  NetflixSettingsViewController.h
//  MetaFlix
//
//  Created by Cyrus Najmabadi on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixSettingsViewController : UITableViewController {
@private
    AbstractNavigationController* navigationController;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController;

@end