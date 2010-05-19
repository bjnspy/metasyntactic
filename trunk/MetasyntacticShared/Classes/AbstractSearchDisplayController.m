// Copyright 2010 Cyrus Najmabadi
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


- (void) initializeData:(AbstractSearchResult*) result AbstractMethod;


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
  searchText = [searchText stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]];

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


- (void) reset {
  [self initializeData:nil];
  [self setupDefaultScopeButtonTitles];
}


- (BOOL)     searchDisplayController:(UISearchDisplayController*) controller
    shouldReloadTableForSearchString:(NSString*) searchText {
  searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if (searchText.length == 0) {
    [self.searchEngine invalidateExistingRequests];
    self.abstractSearchResult = nil;
    [self reset];
    return YES;
    //[self.searchResultsTableView reloadData];
  } else {
    [self.searchEngine submitRequest:searchText];
    return YES;
  }
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
  [self reset];
}

@end
