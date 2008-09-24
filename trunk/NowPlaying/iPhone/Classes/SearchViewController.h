// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchEngineDelegate.h"

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SearchEngineDelegate,UISearchBarDelegate> {
    AbstractNavigationController* navigationController;
    
    SearchEngine* searchEngine;
    SearchResult* searchResult;
    
    UISearchBar* searchBar;
    UITableView* tableView;
}

@property (assign)  AbstractNavigationController* navigationController;

@property (retain) SearchEngine* searchEngine;
@property (retain) SearchResult* searchResult;
@property (retain) UISearchBar* searchBar;
@property (retain) UITableView* tableView;


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController;

- (void) onShow;
- (void) onHide;

@end
