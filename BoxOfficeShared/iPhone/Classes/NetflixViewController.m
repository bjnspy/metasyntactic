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

#import "NetflixViewController.h"

#import "NetflixFeedsViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "NetflixSettingsViewController.h"
#import "NowPlayingCreditsViewController.h"

@interface NetflixViewController()
@property (retain) NetflixAccount* account;
@property (retain) UISearchBar* searchBar;
@end


@implementation NetflixViewController

static const NSInteger ROW_HEIGHT = 46;

typedef enum {
  MostPopularSection,
  DVDSection,
  InstantSection,
  RecommendationsSection,
  AtHomeSection,
  RentalHistorySection,
  AccountsSection,
  LastSection = AccountsSection
} Sections;

@synthesize account;
@synthesize searchBar;

- (void) dealloc {
  self.account = nil;
  self.searchBar = nil;

  [super dealloc];
}


- (void) setupTableStyle {
  self.tableView.rowHeight = ROW_HEIGHT;
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = LocalizedString(@"Netflix", nil);
    [self setupTableStyle];
  }

  return self;
}


- (void) initializeSearchDisplay {
  self.searchBar = [[[UISearchBar alloc] init] autorelease];
  [searchBar sizeToFit];

  self.searchDisplayController = [[[NetflixSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                         contentsController:self] autorelease];
}


- (void) loadView {
  [super loadView];

  [self initializeSearchDisplay];
}


- (BOOL) hasAccount {
  return self.account.userId.length > 0;
}


- (void) setupTitle {
  self.title = LocalizedString(@"Netflix", nil);

  if ([[NetflixSiteStatus status] overQuota]) {
    UILabel* label = [ViewControllerUtilities createTitleLabel];
    label.text = LocalizedString(@"Over Quota - Try Again Later", nil);
    self.navigationItem.titleView = label;
  }
}


- (void) determinePopularMovieCount {
  NSInteger result = 0;
  for (NSString* title in [NetflixRssCache mostPopularTitles]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSInteger count = [[NetflixRssCache cache] movieCountForRSSTitle:title];
      result += count;
    }
    [pool release];
  }

  mostPopularTitleCount = result;
}


- (void) initializeInfoButton {
  self.navigationItem.leftBarButtonItem = [self createInfoButton:@selector(showInfo)];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.account = [[NetflixAccountCache cache] currentAccount];

  if (self.hasAccount) {
    self.tableView.tableHeaderView = searchBar;
  } else {
    self.tableView.tableHeaderView = nil;
  }

  [self initializeInfoButton];
  [self setupTableStyle];
  [self setupTitle];
  [self determinePopularMovieCount];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  if (self.hasAccount) {
    return LastSection + 1;
  } else {
    return 2;
  }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  AutoResizingCell* cell = [[[AutoResizingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  NSInteger row = indexPath.row;
  if (self.hasAccount) {
    switch (row) {
      case MostPopularSection:
        if (mostPopularTitleCount == 0) {
          cell.textLabel.text = LocalizedString(@"Most Popular", @"The most popular movies currently");
        } else {
          cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"%@ (%@)", nil), LocalizedString(@"Most Popular", nil), [NSNumber numberWithInteger:mostPopularTitleCount]];
        }
        break;
      case DVDSection:
        cell.textLabel.text = [[NetflixCache cache] titleForKey:[NetflixConstants discQueueKey] account:account];
        break;
      case InstantSection:
        cell.textLabel.text = [[NetflixCache cache] titleForKey:[NetflixConstants instantQueueKey] account:account];
        break;
      case RecommendationsSection:
        cell.textLabel.text = [[NetflixCache cache] titleForKey:[NetflixConstants recommendationKey] account:account];
        break;
      case AtHomeSection:
        cell.textLabel.text = [[NetflixCache cache] titleForKey:[NetflixConstants atHomeKey] account:account];
        break;
      case RentalHistorySection:
        cell.textLabel.text = LocalizedString(@"Rental History", nil);
        break;
      case AccountsSection:
        cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", LocalizedString(@"Accounts", nil), LocalizedString(@"Profiles", nil)];
        break;
    }
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = LocalizedString(@"Sign Up for New Account", nil);
    } else if (indexPath.row == 1) {
      cell.textLabel.text = LocalizedString(@"Log In to Existing Account", nil);
    }
  }

  if (cell.textLabel.text.length == 0) {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
  }

  return cell;
}


- (void) didSelectAccountsRow {
  UIViewController* controller = [[[NetflixAccountsViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectQueueRow:(NSString*) key {
  UIViewController* controller = [[[NetflixQueueViewController alloc] initWithFeedKey:key] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRentalHistoryRow {
  NSArray* keys =
  [NSArray arrayWithObjects:
   [NetflixConstants rentalHistoryKey],
   [NetflixConstants rentalHistoryWatchedKey],
   [NetflixConstants rentalHistoryReturnedKey],
   [NetflixConstants rentalHistoryShippedKey],
   nil];

  UIViewController* controller =
  [[[NetflixFeedsViewController alloc] initWithFeedKeys:keys
                                                  title:LocalizedString(@"Rental History", nil)] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectRecomendationsRow {
  UIViewController* controller = [[[NetflixRecommendationsViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectAboutSendFeedbackRow {
  UIViewController* controller = [[[CreditsViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectSettingsRow {
  UIViewController* controller = [[[NetflixSettingsViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectMostPopularSection {
  UIViewController* controller = [[[NetflixMostPopularViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) didSelectLoggedInRow:(NSInteger) row {
  switch (row) {
    case MostPopularSection:        return [self didSelectMostPopularSection];
    case DVDSection:                return [self didSelectQueueRow:[NetflixConstants discQueueKey]];
    case InstantSection:            return [self didSelectQueueRow:[NetflixConstants instantQueueKey]];
    case RecommendationsSection:    return [self didSelectRecomendationsRow];
    case AtHomeSection:             return [self didSelectQueueRow:[NetflixConstants atHomeKey]];
    case RentalHistorySection:      return [self didSelectRentalHistoryRow];
    case AccountsSection:           return [self didSelectAccountsRow];
  }
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (self.hasAccount) {
    [self didSelectLoggedInRow:indexPath.row];
  } else {
    if (indexPath.row == 0) {
      NSString* address = @"http://clickserve.cc-dt.com/link/tplclick?lid=41000000029889162&pubid=21000000000265233";
      [self.commonNavigationController pushBrowser:address animated:YES];
    } else if (indexPath.row == 1) {
      UIViewController* controller = [[[NetflixLoginViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    }
  }
}


- (void) showInfo {
  [self.commonNavigationController pushInfoControllerAnimated:YES];
}


- (void) onTabBarItemSelected {
  [searchDisplayController setActive:NO animated:YES];
}


- (NSString*)     tableView:(UITableView*) tableView
    titleForHeaderInSection:(NSInteger)section {
  NetflixUser* user = [[NetflixUserCache cache] userForAccount:account];

  if (searchDisplayController.isActive ||
      [[[NetflixAccountCache cache] accounts] count] <= 1 ||
      user == nil) {
    return nil;
  }

  return [NSString stringWithFormat:LocalizedString(@"Account: %@ %@", "Account: <first name> <last name>"), user.firstName, user.lastName];
}

@end
