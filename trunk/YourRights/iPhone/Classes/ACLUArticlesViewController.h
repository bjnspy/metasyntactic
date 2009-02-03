//
//  ACLUArticlesViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ACLUArticlesViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    NSString* title;
    NSArray* items;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController title:(NSString*) title;

@end
