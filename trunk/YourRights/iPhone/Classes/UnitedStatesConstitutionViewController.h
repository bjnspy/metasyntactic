//
//  UnitedStatesConstitutionViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface UnitedStatesConstitutionViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    Constitution* constitution;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController
                       constitution:(Constitution*) constitution;

@end
