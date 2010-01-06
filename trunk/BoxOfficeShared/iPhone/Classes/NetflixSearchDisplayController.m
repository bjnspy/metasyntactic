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

#import "NetflixSearchDisplayController.h"

#import "CommonNavigationController.h"
#import "Model.h"
#import "MovieCacheUpdater.h"
#import "NetflixCell.h"
#import "NetflixSearchEngine.h"
#import "SearchResult.h"
#import "PersonCacheUpdater.h"

@interface NetflixSearchDisplayController()
@property (retain) NSArray* movies;
@property (retain) NSArray* people;
@end


@implementation NetflixSearchDisplayController

@synthesize movies;
@synthesize people;

- (void) dealloc {
  self.movies = nil;
  self.people = nil;

  [super dealloc];
}


- (void) setupDefaultScopeButtonTitles {
  self.searchBar.scopeButtonTitles =
    [NSArray arrayWithObjects:
     LocalizedString(@"All", @"Option to show 'All' (i.e. non-filtered) results from a search"),
     LocalizedString(@"Movies", nil),
     LocalizedString(@"People", @"i.e. all the people in a film"),
     nil];
}


- (id) initWithSearchBar:(UISearchBar*) searchBar_
     contentsController:(UIViewController*) viewController_ {
  if ((self = [super initWithSearchBar:searchBar_
                    contentsController:viewController_])) {
    self.searchBar.selectedScopeButtonIndex = [Model model].netflixSearchSelectedScopeButtonIndex;
    self.searchBar.placeholder = LocalizedString(@"Search Netflix", nil);
  }

  return self;
}


- (AbstractSearchEngine*) createSearchEngine {
  return [NetflixSearchEngine engineWithDelegate:self];
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger) selectedScope {
  [Model model].netflixSearchSelectedScopeButtonIndex = selectedScope;
  [self reloadTableViewData];
}


- (BOOL) shouldShowAll {
  return self.searchBar.selectedScopeButtonIndex == 0;
}


- (BOOL) shouldShowMovies {
  return self.searchBar.selectedScopeButtonIndex == 1;
}


- (BOOL) shouldShowPeople {
  return self.searchBar.selectedScopeButtonIndex == 2;
}


- (BOOL) noResults {
  if ([self shouldShowAll]) {
    return movies.count == 0 && people.count == 0;
  } else if ([self shouldShowMovies]) {
    return movies.count == 0;
  } else {
    return people.count == 0;
  }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  if ([self shouldShowAll]) {
    return 2;
  } else {
    return 1;
  }
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (searchResult == nil) {
    return 0;
  }

  if ([self noResults]) {
    return 0;
  }

  if ([self shouldShowAll]) {
    if (section == 0) {
      return movies.count;
    } else {
      return people.count;
    }
  } else if ([self shouldShowMovies]) {
    return movies.count;
  } else if ([self shouldShowPeople]) {
    return people.count;
  } else {
    return 0;
  }
}


- (UITableViewCell*) netflixCellForMovie:(Movie*) movie {
  static NSString* reuseIdentifier = @"reuseIdentifier";

  NetflixCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[NetflixCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
  }

  [cell setMovie:movie owner:nil];
  return cell;
}


- (UITableViewCell*) noResultsCell {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"No results found for '%@'", nil), searchResult.value];
  return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if ([self noResults]) {
    return [self noResultsCell];
  }

  if ([self shouldShowAll]) {
    if (indexPath.section == 0) {
      Movie* movie = [movies objectAtIndex:indexPath.row];
      return [self netflixCellForMovie:movie];
    } else {
      Person* person = [people objectAtIndex:indexPath.row];
      UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
      cell.textLabel.text = person.name;
      return cell;
    }
  } else if ([self shouldShowMovies]) {
    Movie* movie = [movies objectAtIndex:indexPath.row];
    return [self netflixCellForMovie:movie];
  } else if ([self shouldShowPeople]) {
    Person* person = [people objectAtIndex:indexPath.row];
    UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
    cell.textLabel.text = person.name;
    return cell;
  } else {
    return [[[UITableViewCell alloc] init] autorelease];
  }
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if ([self shouldShowAll]) {
    if (indexPath.section == 0) {
      Movie* movie = [movies objectAtIndex:indexPath.row];
      [self.commonNavigationController pushMovieDetails:movie animated:YES];
    } else {
      Person* person = [people objectAtIndex:indexPath.row];
      [self.commonNavigationController pushPersonDetails:person animated:YES];
    }
  } else if ([self shouldShowMovies]) {
    Movie* movie = [movies objectAtIndex:indexPath.row];
    [self.commonNavigationController pushMovieDetails:movie animated:YES];
  } else if ([self shouldShowPeople]) {
    Person* person = [people objectAtIndex:indexPath.row];
    [self.commonNavigationController pushPersonDetails:person animated:YES];
  }
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 1) {
    return self.searchResultsTableView.rowHeight;
  }

  if ([self shouldShowPeople]) {
    return self.searchResultsTableView.rowHeight;
  }

  if (searchResult != nil) {
    return 100;
  }

  return self.searchResultsTableView.rowHeight;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if ([self noResults]) {
    if (section == 0) {
      return LocalizedString(@"No information found", nil);
    } else {
      return nil;
    }
  }

  if ([self shouldShowAll]) {
    if (movies.count > 0 && people.count > 0) {
      if (section == 0) {
        return LocalizedString(@"Movies", nil);
      } else {
        return LocalizedString(@"People", nil);
      }
    }
  }

  return nil;
}


- (void) initializeData:(SearchResult*) result {
  self.movies = result.movies;
  self.people = result.people;

  self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                      [NSString stringWithFormat:LocalizedString(@"All (%d)", @"Used to display the count of all search results.  i.e.: All (15)"), movies.count + people.count],
                                      [NSString stringWithFormat:LocalizedString(@"Movies (%d)", @"Used to display the count of all movie search results.  i.e.: Movies (15)"), movies.count],
                                      [NSString stringWithFormat:LocalizedString(@"People (%d)", @"Used to display the count of all people search results.  i.e.: People (5)"), people.count],
                                      nil];
}


- (void) reportResult:(SearchResult*) result {
  [self initializeData:result];
  [super reportResult:result];

  if (result.movies.count > 0) {
    // download the details for these movies in the background.
    [[MovieCacheUpdater updater] addSearchMovies:result.movies];
  }

  if (result.people.count > 0) {
    [[PersonCacheUpdater updater] addSearchPeople:result.people];
  }
}

@end
