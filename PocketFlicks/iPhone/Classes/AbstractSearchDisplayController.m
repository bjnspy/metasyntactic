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

#ifdef IPHONE_OS_VERSION_3
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
@property (retain) AbstractSearchEngine* searchEngineData;
@property (retain) SearchResult* searchResult;
@end

@implementation AbstractSearchDisplayController

@synthesize searchEngineData;
@synthesize searchResult;

- (void) dealloc {
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


- (void) setupDefaultScopeButtonTitles {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id)initWithSearchBar:(UISearchBar*) searchBar__
     contentsController:(UIViewController*) viewController__ {
    if (self = [super initWithSearchBar:searchBar__ contentsController:viewController__]) {
        self.delegate = self;
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;

        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBar.showsScopeBar = YES;

        [self setupDefaultScopeButtonTitles];
    }

    return self;
}


- (AbstractNavigationController*) abstractNavigationController {
    return [(id)self.searchContentsController abstractNavigationController];
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
        [self setupDefaultScopeButtonTitles];
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


- (void) reload {
    for (id cell in self.searchResultsTableView.visibleCells) {
        if ([cell respondsToSelector:@selector(loadImage)]) {
            [cell loadImage];
        }
    }
}


- (void) majorRefresh {
    [self reload];
}


- (void) minorRefresh {
    [self reload];
}

@end
#endif