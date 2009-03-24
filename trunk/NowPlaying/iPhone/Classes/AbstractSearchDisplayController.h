//
//  AbstractSearchDisplayController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchEngineDelegate.h"

@interface AbstractSearchDisplayController : UISearchDisplayController<UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,SearchEngineDelegate> {
@protected
    AbstractNavigationController* navigationController;
    AbstractSearchEngine* searchEngineData;
    SearchResult* searchResult;
}

- (id) initNavigationController:(AbstractNavigationController*) navigationController
                      searchBar:(UISearchBar*) searchBar
             contentsController:(UIViewController*) viewController;

- (void) majorRefresh;
- (void) minorRefresh;

@end