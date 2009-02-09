//
//  ConstitutionAmendmentViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ConstitutionAmendmentViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    Amendment* amendment;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController
                          amendment:(Amendment*) amendment;

@end
