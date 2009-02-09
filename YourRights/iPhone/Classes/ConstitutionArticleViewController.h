//
//  ConstitutionArticleViewController.h
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ConstitutionArticleViewController : UITableViewController {
@private
    YourRightsNavigationController* navigationController;
    Article* article;
}

- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController
                            article:(Article*) article;

@end
