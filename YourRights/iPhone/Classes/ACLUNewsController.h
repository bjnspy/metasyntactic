//
//  ACLUNewsController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ACLUNewsController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController;

@end
