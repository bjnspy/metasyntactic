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

#import "AbstractSearchEngine.h"
#import "AbstractSearchResult.h"
#import "MetasyntacticSharedApplication.h"

@interface AbstractSearchDisplayController()
@property (retain) AbstractSearchEngine* searchEngineData;
@property (retain) AbstractSearchResult* abstractSearchResult;
@end

@implementation AbstractSearchDisplayController

@synthesize searchEngineData;
@synthesize abstractSearchResult;

- (void) dealloc {
  self.searchEngineData = nil;
  self.abstractSearchResult = nil;

  [super dealloc];
}


- (void) setupDefaultScopeButtonTitles AbstractMethod;


- (AbstractSearchEngine*) createSearchEngine AbstractMethod;


- (BOOL) foundMatches AbstractMethod;


- (NSInteger) numberOfSectionsInTableViewWorker AbstractMethod;


- (NSInteger) numberOfRowsInSectionWorker:(NSInteger) section AbstractMethod;


- (UITableViewCell*) cellForRowAtIndexPathWorker:(NSIndexPath*) indexPath AbstractMethod;


- (void) didSelectRowAtIndexPathWorker:(NSIndexPath*) indexPath AbstractMethod;


- (NSString*) titleForHeaderInSectionWorker:(NSInteger) section AbstractMethod;


- (CGFloat) heightForRowAtIndexPathWorker:(NSIndexPath*) indexPath AbstractMethod;


- (id) initWithSearchBar:(UISearchBar*) searchBar_
      contentsController:(UITableViewController*) viewController_ {
  if ((self = [super initWithSearchBar:searchBar_ contentsController:viewController_])) {
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


- (UITableView*) tableView {
  return [self searchResultsTableView];
}


- (AbstractSearchEngine*) searchEngine {
  if (searchEngineData == nil) {
    self.searchEngineData = [self createSearchEngine];
  }

  return searchEngineData;
}


- (NSString*) searchText {
  NSString* searchText = self.searchBar.text;
  searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  return searchText;
}


- (BOOL) searching {
  NSString* searchText = self.searchText;
  return searchText.length > 0 && ![searchText isEqual:abstractSearchResult.value];
}


- (void) reportResult:(AbstractSearchResult*) result {
  NSAssert([NSThread isMainThread], nil);
  self.abstractSearchResult = result;
  [self.searchResultsTableView reloadData];
}


- (BOOL)     searchDisplayController:(UISearchDisplayController*) controller
    shouldReloadTableForSearchString:(NSString*) searchText {
  searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if (searchText.length == 0) {
    [self setupDefaultScopeButtonTitles];
    [self.searchEngine invalidateExistingRequests];
    self.abstractSearchResult = nil;
    //[self.searchResultsTableView reloadData];
  } else {
    [self.searchEngine submitRequest:searchText];
  }

  return YES;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  if (![self foundMatches]) {
    return 1;
  }

  return self.numberOfSectionsInTableViewWorker;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (![self foundMatches]) {
    if (self.searching) {
      // Show "Searching ..."
      return 1;
    } else {
      return 0;
    }
  }

  return [self numberOfRowsInSectionWorker:section];
}


- (UITableViewCell*) searchingCell {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:nil] autorelease];
  cell.textLabel.text = LocalizedString(@"Searching", nil);
  UIActivityIndicatorView* view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
  [view startAnimating];
  cell.accessoryView = view;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (![self foundMatches]) {
    return [self searchingCell];
  }

  return [self cellForRowAtIndexPathWorker:indexPath];
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (![self foundMatches]) {
    return;
  }

  [self didSelectRowAtIndexPathWorker:indexPath];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (![self foundMatches]) {
    return nil;
  }

  return [self titleForHeaderInSectionWorker:section];
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (![self foundMatches]) {
    return tableView_.rowHeight;
  }

  return [self heightForRowAtIndexPathWorker:indexPath];
}


- (void) reloadTableViewData {
  [self.searchResultsTableView reloadData];
}


- (void) reloadVisibleCells {
  [self.searchResultsTableView reloadRowsAtIndexPaths:self.searchResultsTableView.indexPathsForVisibleRows
                                     withRowAnimation:UITableViewRowAnimationNone];
}


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController*) controller {
  [self setupDefaultScopeButtonTitles];
}

@end
