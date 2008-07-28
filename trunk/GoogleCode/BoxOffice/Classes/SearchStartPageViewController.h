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

    UIActivityIndicatorView* activityIndicator;
    UIView* activityView;
    NSInteger searchCount;

    NSInteger searchId;
    XmlElement* searchResult;

    NSArray* recentResults;
}

@property (assign) SearchNavigationController* navigationController;
@property (retain) UISearchBar* searchBar;
@property (retain) UIActivityIndicatorView* activityIndicator;
@property (retain) UIView* activityView;
@property (retain) XmlElement* searchResult;
@property (retain) NSArray* recentResults;

@property (readonly) XmlElement* peopleElement;
@property (readonly) XmlElement* moviesElement;
@property (readonly) NSArray* people;
@property (readonly) NSArray* movies;

- (id) initWithNavigationController:(SearchNavigationController*) navigationController;

- (void) refresh;
- (BoxOfficeModel*) model;


@end
