//
//  SearchDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxOfficeModel.h"

@class SearchNavigationController;

@interface SearchDetailsViewController : UITableViewController {
    SearchNavigationController* navigationController;
}

@property (assign) SearchNavigationController* navigationController;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController;

- (BoxOfficeModel*) model;

@end
