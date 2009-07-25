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
#import "MutableNetflixCache.h"
#import "NetflixFeedsViewController.h"
#import "NetflixLoginViewController.h"
#import "NetflixMostPopularViewController.h"
#import "NetflixNavigationController.h"
#import "NetflixQueueViewController.h"
#import "NetflixRecommendationsViewController.h"
#import "NetflixSearchDisplayController.h"
#import "NetflixSettingsViewController.h"
#import "PocketFlicksCreditsViewController.h"

@interface PocketFlicksViewController()
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
  LogOutSection,
  LastSection = LogOutSection
} Sections;

@synthesize searchBar;

- (void) dealloc {
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
  searchBar.tintColor = [ColorCache netflixYellow];
  [searchBar sizeToFit];

  self.searchDisplayController = [[[NetflixSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                         contentsController:self] autorelease];
}


- (void) loadView {
  [super loadView];

  [self initializeSearchDisplay];
}


- (BOOL) hasAccount {
  return self.model.netflixUserId.length > 0;
}


- (void) setupTitle {
  if (self.model.netflixCache.lastQuotaErrorDate != nil &&
      self.model.netflixCache.lastQuotaErrorDate.timeIntervalSinceNow < (5 * ONE_MINUTE)) {
    self.title = LocalizedString(@"Over Quota - Try Again Later", nil);
  } else {
    self.title = [Application name];
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
  return;
  UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
  [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

  infoButton.contentMode = UIViewContentModeCenter;
  CGRect frame = infoButton.frame;
  frame.size.width += 4;
  infoButton.frame = frame;
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
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
  return 9;
}


- (NetflixCache*) netflixCache {
  return self.model.netflixCache;
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
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache dvdQueueKey]];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixDVDQueue.png");
        break;
      case InstantSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache instantQueueKey]];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixInstantQueue.png");
        break;
      case RecommendationsSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache recommendationKey]];
        cell.imageView.image = BoxOfficeStockImage(@"NetflixRecommendations.png");
        break;
      case AtHomeSection:
        cell.textLabel.text = [self.netflixCache titleForKey:[NetflixCache atHomeKey]];
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
      case LogOutSection:
        cell.textLabel.text = LocalizedString(@"Log Out of Netflix", nil);
        cell.imageView.image = BoxOfficeStockImage(@"NetflixLogOff.png");
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
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


- (void) didSelectLogoutRow {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                   message:LocalizedString(@"Really log out of Netflix?", nil)
                                                  delegate:nil
                                         cancelButtonTitle:LocalizedString(@"No", nil)
                                         otherButtonTitles:LocalizedString(@"Yes", nil), nil] autorelease];

  alert.delegate = self;
  [alert show];
}


- (void)         alertView:(UIAlertView*) alertView
      clickedButtonAtIndex:(NSInteger) index {
  [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
  if (index != alertView.cancelButtonIndex) {
    [self.controller setNetflixKey:nil secret:nil userId:nil];
    [Application resetNetflixDirectories];

    [self majorRefresh];
  }
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
    case DVDSection:                return [self didSelectQueueRow:[NetflixCache dvdQueueKey]];
    case InstantSection:            return [self didSelectQueueRow:[NetflixCache instantQueueKey]];
    case RecommendationsSection:    return [self didSelectRecomendationsRow];
    case AtHomeSection:             return [self didSelectQueueRow:[NetflixCache atHomeKey]];
    case RentalHistorySection:      return [self didSelectRentalHistoryRow];
    case AboutSendFeedbackSection:  return [self didSelectAboutSendFeedbackRow];
    case LogOutSection:             return [self didSelectLogoutRow];
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


- (void) showInfo {
  [self.commonNavigationController pushInfoControllerAnimated:YES];
}


- (void) onTabBarItemSelected {
  [searchDisplayController setActive:NO animated:YES];
}

@end
