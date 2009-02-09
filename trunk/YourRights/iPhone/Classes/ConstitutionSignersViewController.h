//
//  ConstitutionArticleViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ConstitutionSignersViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    MultiDictionary* signers;
    NSArray* keys;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController
                            signers:(MultiDictionary*) signers;

@end
