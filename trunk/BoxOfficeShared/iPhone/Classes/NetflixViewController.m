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

#import "NetflixViewController.h"

#import "Application.h"
#import "BoxOfficeStockImages.h"
#import "Controller.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixAccount.h"
#import "NetflixAccountsViewController.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "NetflixSettingsViewController.h"
#import "NetflixUser.h"
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


- (Model*) model {
  return [Model model];
}


- (Controller*) controller {
  return [Controller controller];
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
  if (self.model.netflixCache.lastQuotaErrorDate != nil &&
      self.model.netflixCache.lastQuotaErrorDate.timeIntervalSinceNow < (5 * ONE_MINUTE)) {
    self.title = LocalizedString(@"Over Quota - Try Again Later", nil);
  } else {
    self.title = LocalizedString(@"Netflix", nil);
  }
}


- (void) determinePopularMovieCount {
  NSInteger result = 0;
  for (NSString* title in [NetflixCache mostPopularTitles]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
      result += count;
    }
    [pool release];
  }

  mostPopularTitleCount = result;
}


- (void) initializeInfoButton {
  UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
  [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

  infoButton.contentMode = UIViewContentModeCenter;
  CGRect frame = infoButton.frame;
  frame.size.width += 4;
  infoButton.frame = frame;
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.account = self.model.currentNetflixAccount;

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


- (NetflixCache*) netflixCache {
  return self.model.netflixCache;
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
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache dvdQueueKey] account:account];
        break;
      case InstantSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache instantQueueKey] account:account];
        break;
      case RecommendationsSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache recommendationKey] account:account];
        break;
      case AtHomeSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache atHomeKey] account:account];
        break;
      case RentalHistorySection:
        cell.textLabel.text = LocalizedString(@"Rental History", nil);
        break;
      case AccountsSection:
        cell.textLabel.text = LocalizedString(@"Accounts", nil);
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
   [NetflixCache rentalHistoryKey],
   [NetflixCache rentalHistoryWatchedKey],
   [NetflixCache rentalHistoryReturnedKey],
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
    case DVDSection:                return [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
    case InstantSection:            return [self didSelectQueueRow:[NetflixCache instantQueueKey]];
    case RecommendationsSection:    return [self didSelectRecomendationsRow];
    case AtHomeSection:             return [self didSelectQueueRow:[NetflixCache atHomeKey]];
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
      NSString* address = @"http://click.linksynergy.com/fs-bin/click?id=eOCwggduPKg&offerid=161458.10000264&type=3&subid=0";
      [self.commonNavigationController pushBrowser:address animated:YES];
    } else if (indexPath.row == 1) {
      NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] init] autorelease];
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NetflixUser* user = [self.model.netflixCache userForAccount:account];

  if (self.model.netflixAccounts.count <= 1 || user == nil) {
    return nil;
  }

  return [NSString stringWithFormat:LocalizedString(@"%@ %@", "<first name> <last name>"), user.firstName, user.lastName];
}

@end
