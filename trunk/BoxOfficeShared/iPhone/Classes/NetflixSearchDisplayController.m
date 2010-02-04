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
#import "PersonCacheUpdater.h"
#import "SearchResult.h"

@interface NetflixSearchDisplayController()
@property (retain) NSArray* dvdMovies;
@property (retain) NSArray* blurayMovies;
@property (retain) NSArray* instantMovies;
@property (retain) NSArray* people;
@end

@implementation NetflixSearchDisplayController

@synthesize dvdMovies;
@synthesize blurayMovies;
@synthesize instantMovies;
@synthesize people;

- (void) dealloc {
  self.dvdMovies = nil;
  self.blurayMovies = nil;
  self.instantMovies = nil;
  self.people = nil;

  [super dealloc];
}


- (void) setupDefaultScopeButtonTitles {
  self.searchBar.scopeButtonTitles =
  [NSArray arrayWithObjects:
   LocalizedString(@"DVD", nil),
   LocalizedString(@"Bluray", nil),
   LocalizedString(@"Instant", @"search category for instant watch films"),
   LocalizedString(@"People", nil),
   nil];
}


- (id) initWithSearchBar:(UISearchBar*) searchBar_
     contentsController:(UITableViewController*) viewController_ {
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


- (BOOL) shouldShowDvd {
  return self.searchBar.selectedScopeButtonIndex == 0;
}


- (BOOL) shouldShowBluray {
  return self.searchBar.selectedScopeButtonIndex == 1;
}


- (BOOL) shouldShowInstant {
  return self.searchBar.selectedScopeButtonIndex == 2;
}


- (BOOL) shouldShowPeople {
  return self.searchBar.selectedScopeButtonIndex == 3;
}


- (SearchResult*) searchResult {
  return (id)abstractSearchResult;
}


- (BOOL) foundMatches {
  if ([self shouldShowDvd]) {
    return dvdMovies.count > 0;
  } else if ([self shouldShowBluray]) {
    return blurayMovies.count > 0;
  } else if ([self shouldShowInstant]) {
    return instantMovies.count > 0;
  } else {
    return people.count > 0;
  }
}


- (NSInteger) numberOfSectionsInTableViewWorker {
  return 1;
}


- (NSInteger) numberOfRowsInSectionWorker:(NSInteger) section {
  if ([self shouldShowDvd]) {
    return dvdMovies.count;
  } else if ([self shouldShowBluray]) {
    return blurayMovies.count;
  } else if ([self shouldShowInstant]) {
    return instantMovies.count;
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
    cell = [[[NetflixCell alloc] initWithReuseIdentifier:reuseIdentifier
                                     tableViewController:(id)self.searchContentsController] autorelease];
  }

  [cell setMovie:movie owner:nil];
  return cell;
}


- (UITableViewCell*) cellForRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if ([self shouldShowDvd]) {
    Movie* movie = [dvdMovies objectAtIndex:indexPath.row];
    return [self netflixCellForMovie:movie];
  } else if ([self shouldShowBluray]) {
    Movie* movie = [blurayMovies objectAtIndex:indexPath.row];
    return [self netflixCellForMovie:movie];
  } else if ([self shouldShowInstant]) {
    Movie* movie = [instantMovies objectAtIndex:indexPath.row];
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


- (CommonNavigationController*) commonNavigationController {
  return (id)self.searchContentsController.navigationController;
}


- (void) didSelectRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if ([self shouldShowDvd]) {
    Movie* movie = [dvdMovies objectAtIndex:indexPath.row];
    [self.commonNavigationController pushMovieDetails:movie animated:YES];
  } else if ([self shouldShowBluray]) {
    Movie* movie = [blurayMovies objectAtIndex:indexPath.row];
    [self.commonNavigationController pushMovieDetails:movie animated:YES];
  } else if ([self shouldShowInstant]) {
    Movie* movie = [instantMovies objectAtIndex:indexPath.row];
    [self.commonNavigationController pushMovieDetails:movie animated:YES];
  } else if ([self shouldShowPeople]) {
    Person* person = [people objectAtIndex:indexPath.row];
    [self.commonNavigationController pushPersonDetails:person animated:YES];
  }
}


- (CGFloat) heightForRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if ([self shouldShowDvd] ||
      [self shouldShowBluray] ||
      [self shouldShowInstant]) {
    return 100;
  }

  return self.searchResultsTableView.rowHeight;
}


- (NSString*) titleForHeaderInSectionWorker:(NSInteger) section {
  return nil;
}


- (void) initializeData:(SearchResult*) result {
  NSMutableArray* dvds = [NSMutableArray array];
  NSMutableArray* bluray = [NSMutableArray array];
  NSMutableArray* instant = [NSMutableArray array];

  for (Movie* movie in result.movies) {
    if ([[NetflixCache cache] isDvd:movie]) {
      [dvds addObject:movie];
    }
    if ([[NetflixCache cache] isBluray:movie]) {
      [bluray addObject:movie];
    }
    if ([[NetflixCache cache] isInstantWatch:movie]) {
      [instant addObject:movie];
    }
  }

  self.dvdMovies = dvds;
  self.blurayMovies = bluray;
  self.instantMovies = instant;
  self.people = result.people;

  NSString* dvdString     = dvdMovies.count     == 0 ? LocalizedString(@"DVD", nil)     : [NSString stringWithFormat:LocalizedString(@"DVD (%d)", @"Used to display the count of dvd search results.  i.e.: DVD (15)"), dvdMovies.count];
  NSString* blurayString  = blurayMovies.count  == 0 ? LocalizedString(@"Bluray", nil)  : [NSString stringWithFormat:LocalizedString(@"Bluray (%d)", @"Used to display the count of bluray search results.  i.e.: Bluray (15)"), blurayMovies.count];
  NSString* instantString = instantMovies.count == 0 ? LocalizedString(@"Instant", nil) : [NSString stringWithFormat:LocalizedString(@"Instant (%d)", @"Used to display the count of instant search results.  i.e.: Instant (15)"), instantMovies.count];
  NSString* peopleString  = people.count        == 0 ? LocalizedString(@"People", nil)  : [NSString stringWithFormat:LocalizedString(@"People (%d)", @"Used to display the count of people search results.  i.e.: People (5)"), people.count];

  self.searchBar.scopeButtonTitles =
    [NSArray arrayWithObjects:
     dvdString,
     blurayString,
     instantString,
     peopleString, nil];
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
