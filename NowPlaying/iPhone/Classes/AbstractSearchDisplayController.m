// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AbstractSearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "ApplicationTabBarController.h"
#import "Controller.h"
#import "DVDCell.h"
#import "LocalSearchEngine.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@interface AbstractSearchDisplayController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) AbstractSearchEngine* searchEngineData;
@property (retain) SearchResult* searchResult;
@end

@implementation AbstractSearchDisplayController

@synthesize navigationController;
@synthesize searchEngineData;
@synthesize searchResult;

- (void) dealloc {
    self.navigationController = nil;
    self.searchEngineData = nil;
    self.searchResult = nil;

    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (id)initNavigationController:(AbstractNavigationController*) navigationController_
                     searchBar:(UISearchBar *)searchBar_
            contentsController:(UIViewController *)viewController_ {
    if (self = [super initWithSearchBar:searchBar_ contentsController:viewController_]) {
        self.navigationController = navigationController_;

        self.delegate = self;
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;

        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBar.showsScopeBar = YES;
    }

    return self;
}


- (BOOL) sortingByTitle {
    return YES;
}


- (AbstractSearchEngine*) createSearchEngine {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (AbstractSearchEngine*) searchEngine {
    if (searchEngineData == nil) {
        self.searchEngineData = [self createSearchEngine];
    }

    return searchEngineData;
}


- (BOOL) searching {
    NSString* searchText = self.searchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return searchText.length > 0 && ![searchText isEqual:searchResult.value];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);
    self.searchResult = result;
    [self.searchResultsTableView reloadData];
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (searchText.length == 0) {
        [self.searchEngine invalidateExistingRequests];
        self.searchResult = nil;
        [self.searchResultsTableView reloadData];
        return YES;
    } else {
        [self.searchEngine submitRequest:searchText];
        return NO;
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [[[UITableViewCell alloc] init] autorelease];
}


- (void) majorRefresh {

}


- (void) minorRefresh {

}

@end