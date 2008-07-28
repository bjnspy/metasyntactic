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

    UIActivityIndicatorView* activityIndicator;
    UIView* activityView;
}

@property (assign) SearchNavigationController* navigationController;
@property (retain) UIActivityIndicatorView* activityIndicator;
@property (retain) UIView* activityView;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController;

- (BoxOfficeModel*) model;

- (void) startActivityIndicator;
- (void) stopActivityIndicator;

@end
