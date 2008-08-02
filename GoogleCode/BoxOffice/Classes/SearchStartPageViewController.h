// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
