//
//  DeclarationOfIndependenceViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface DeclarationOfIndependenceViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    DeclarationOfIndependence* declaration;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController
                        declaration:(DeclarationOfIndependence*) declaration;

@end
