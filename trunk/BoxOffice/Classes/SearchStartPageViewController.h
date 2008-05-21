//
//  SearchStartPageViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxOfficeModel.h"
#import "ActivityIndicator.h"

@class SearchNavigationController;

@interface SearchStartPageViewController : UITableViewController<UISearchBarDelegate> {
    SearchNavigationController* navigationController;
    UISearchBar* searchBar;
    
    ActivityIndicator* activityIndicator;
}

@property (assign) SearchNavigationController* navigationController;
@property (retain) UISearchBar* searchBar;
@property (retain) ActivityIndicator* activityIndicator;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController;

- (void) refresh;
- (BoxOfficeModel*) model;


@end
