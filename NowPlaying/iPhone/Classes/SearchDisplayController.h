//
//  SearchDisplayController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchEngineDelegate.h"

@interface SearchDisplayController : UISearchDisplayController<UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,SearchEngineDelegate> {
@private
    AbstractNavigationController* navigationController;
    SearchEngine* searchEngine;
    SearchResult* searchResult;  
}


- (id)initNavigationController:(AbstractNavigationController*) navigationController
                 searchBar:(UISearchBar *)searchBar
            contentsController:(UIViewController *)viewController;

@end
