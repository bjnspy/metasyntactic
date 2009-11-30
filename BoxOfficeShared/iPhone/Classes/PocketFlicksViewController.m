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

#import "PocketFlicksViewController.h"

#import "Application.h"
#import "BoxOfficeStockImages.h"
#import "Controller.h"
#import "Model.h"
#import "NetflixFeedsViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "NetflixSettingsViewController.h"
#import "PocketFlicksCreditsViewController.h"
#import "PocketFlicksSettingsViewController.h"

@interface PocketFlicksViewController()
@property (retain) NetflixAccount* account;
@property (retain) UISearchBar* searchBar;
@end


@implementation PocketFlicksViewController

static const NSInteger ROW_HEIGHT = 46;

typedef enum {
  MostPopularSection,
  DVDSection,
  InstantSection,
  RecommendationsSection,
  AtHomeSection,
  RentalHistorySection,
  AboutSendFeedbackSection,
  AccountsSection,
  LastSection
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
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [ColorCache netflixRed];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = [Application name];
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
  searchBar.tintColor = [StyleSheet searchBarTintColor];
  [searchBar sizeToFit];

  self.searchDisplayController = [[[NetflixSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                         contentsController:self] autorelease];
}


- (void) loadView {
  [super loadView];

  [self initializeSearchDisplay];
}


- (void) showInfo {
  UIViewController* controller = [[[PocketFlicksSettingsViewController alloc] init] autorelease];

  UINavigationController* navigationController = [[[AbstractNavigationController alloc] initWithRootViewController:controller] autorelease];
  if (![Application isIPhone3G]) {
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  }
  [self presentModalViewController:navigationController animated:YES];
}


- (BOOL) hasAccount {
  return account.userId.length > 0;
}


- (MutableNetflixCache*) netflixCache {
  return [MutableNetflixCache cache];
}


- (void) setupTitle {
  self.title = [Application name];

  NSDate* lastQuotaErrorDate = [[NetflixSiteStatus status] lastQuotaErrorDate];
  if (lastQuotaErrorDate != nil &&
      lastQuotaErrorDate.timeIntervalSinceNow < (5 * ONE_MINUTE)) {
    UILabel* label = [ViewControllerUtilities createTitleLabel];
    label.text = LocalizedString(@"Over Quota - Try Again Later", nil);
    self.navigationItem.titleView = label;
  }
}


- (NetflixRssCache*) netflixRssCache {
  return [NetflixRssCache cache];
}


- (void) determinePopularMovieCount {
  NSInteger result = 0;
  for (NSString* title in [NetflixRssCache mostPopularTitles]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSInteger count = [self.netflixRssCache movieCountForRSSTitle:title];
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
    return 8;
  } else {
    return 9;
  }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  AutoResizingCell* cell = [[[AutoResizingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];

  cell.textLabel.textColor = [UIColor whiteColor];
  cell.accessoryView = [[[UIImageView alloc] initWithImage:BoxOfficeStockImage(@"NetflixChevron.png")] autorelease];

  NSInteger row = indexPath.row;
  if (self.hasAccount) {
    switch (row) {
      case MostPopularSection:
        if (mostPopularTitleCount == 0) {
          cell.textLabel.text = LocalizedString(@"Most Popular", @"The most popular movies currently");
        } else {
          cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"%@ (%@)", nil), LocalizedString(@"Most Popular", nil), [NSNumber numberWithInteger:mostPopularTitleCount]];
        }
        cell.imageView.image = BoxOfficeStockImage(@"NetflixMostPopular.png");
        break;
      case DVDSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixConstants discQueueKey] account:account];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixDVDQueue.png");
        break;
      case InstantSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixConstants instantQueueKey] account:account];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixInstantQueue.png");
        break;
      case RecommendationsSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixConstants recommendationKey] account:account];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixRecommendations.png");
        break;
      case AtHomeSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixConstants atHomeKey] account:account];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixHome.png");
        break;
      case RentalHistorySection:
        cell.textLabel.text = LocalizedString(@"Rental History", nil);
        cell.imageView.image = BoxOfficeStockImage(@"NetflixHistory.png");
        break;
      case AboutSendFeedbackSection:
        cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", LocalizedString(@"Send Feedback", nil), LocalizedString(@"Write Review", nil)];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixCredits.png");
        break;
      case AccountsSection:
        cell.textLabel.text = LocalizedString(@"Accounts", nil);
        cell.imageView.image = BoxOfficeStockImage(@"NetflixLogOff.png");
        break;
    }
  } else {
    if (indexPath.row == 2) {
      cell.textLabel.text = LocalizedString(@"Sign Up for New Account", nil);
      cell.imageView.image = BoxOfficeStockImage(@"NetflixSettings.png");
    } else if (indexPath.row == 0) {
      cell.textLabel.text = LocalizedString(@"Log In to Existing Account", nil);
      cell.imageView.image = BoxOfficeStockImage(@"NetflixLogOff.png");
    } else if (indexPath.row == 1) {
      cell.textLabel.text = LocalizedString(@"Send Feedback", nil);
      cell.imageView.image = BoxOfficeStockImage(@"NetflixCredits.png");
    }
  }

  if (cell.textLabel.text.length == 0) {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = nil;
  }

  NSString* backgroundName = [NSString stringWithFormat:@"NetflixCellBackground-%d.png", row];
  NSString* selectedBackgroundName = [NSString stringWithFormat:@"NetflixCellSelectedBackground-%d.png", row];
  UIImageView* backgroundView = [[[UIImageView alloc] initWithImage:BoxOfficeStockImage(backgroundName)] autorelease];
  UIImageView* selectedBackgroundView = [[[UIImageView alloc] initWithImage:BoxOfficeStockImage(selectedBackgroundName)] autorelease];
  backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  cell.backgroundView = backgroundView;
  cell.selectedBackgroundView = selectedBackgroundView;

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
  UIViewController* controller = [[[PocketFlicksCreditsViewController alloc] init] autorelease];
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
    case AboutSendFeedbackSection:  return [self didSelectAboutSendFeedbackRow];
    case AccountsSection:           return [self didSelectAccountsRow];
  }
}


- (CommonNavigationController*) commonNavigationController {
  return (id)self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (self.hasAccount) {
    [self didSelectLoggedInRow:indexPath.row];
  } else {
    if (indexPath.row == 2) {
      NSString* address = @"http://click.linksynergy.com/fs-bin/click?id=eOCwggduPKg&offerid=161458.10000264&type=3&subid=0";
      [self.commonNavigationController pushBrowser:address animated:YES];
    } else if (indexPath.row == 0) {
      NetflixLoginViewController* controller = [[[NetflixLoginViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 1) {
      [self didSelectAboutSendFeedbackRow];
    }
  }
}


- (void) onTabBarItemSelected {
  [searchDisplayController setActive:NO animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  NetflixUser* user = [[NetflixUserCache cache] userForAccount:account];

  if (searchDisplayController.isActive ||
      self.model.netflixAccounts.count <= 1 ||
      user == nil) {
    return nil;
  }

  CGRect frame = CGRectMake(12, -1, 480, 23);

  UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
  label.text = [NSString stringWithFormat:LocalizedString(@"Account: %@ %@", "Account: <first name> <last name>"), user.firstName, user.lastName];
  label.font = [UIFont boldSystemFontOfSize:18];
  label.textColor = [UIColor whiteColor];
  label.shadowOffset = CGSizeMake(0, 1);
  label.shadowColor = [UIColor darkGrayColor];
  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  frame.origin.x = 0;
  frame.origin.y = 0;
  UIImage* image = BoxOfficeStockImage(@"PocketflicksHeader.png");
  UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
  imageView.alpha = 0.9f;
  imageView.frame = frame;
  imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];
  view.autoresizesSubviews = YES;
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  [view addSubview:imageView];
  [view addSubview:label];

  return view;
}

@end
