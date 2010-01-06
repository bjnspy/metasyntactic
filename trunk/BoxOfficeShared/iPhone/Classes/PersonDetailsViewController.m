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

#import "PersonDetailsViewController.h"

#import "BookmarkCache.h"
#import "BoxOfficeStockImages.h"
#import "CollapsedMovieDetailsCell.h"
#import "DVD.h"
#import "ExpandedMovieDetailsCell.h"
#import "FavoriteTheaterCache.h"
#import "LargePosterCache.h"
#import "LookupResult.h"
#import "Model.h"
#import "MovieCacheUpdater.h"
#import "MovieShowtimesCell.h"
#import "NetflixRatingsCell.h"
#import "NetflixStatusCell.h"
#import "Score.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"
#import "UpcomingCache.h"
#import "Utilities.h"
#import "PersonCacheUpdater.h"

@interface PersonDetailsViewController()
@property (retain) Person* person;
@property (retain) NetflixAccount* netflixAccount;
@property (retain) NSDictionary* websites;
@property (retain) ActionsView* actionsView;
@property (retain) UIImage* posterImage;
@property (retain) TappableImageView* posterImageView;
@property (retain) NSDictionary* buttonIndexToActionMap;
@end


@implementation PersonDetailsViewController

static const NSInteger VISIT_WEBSITES_TAG = 4;
static const NSInteger POSTER_TAG = -1;

@synthesize person;
@synthesize netflixAccount;
@synthesize websites;
@synthesize actionsView;
@synthesize posterImage;
@synthesize posterImageView;
@synthesize buttonIndexToActionMap;

- (void) dealloc {
  self.person = nil;
  self.netflixAccount = nil;
  self.websites = nil;
  self.actionsView = nil;
  self.posterImage = nil;
  self.posterImageView = nil;
  self.buttonIndexToActionMap = nil;
  
  [super dealloc];
}


- (void) setupActionsView {
  NSMutableArray* selectors = [NSMutableArray array];
  NSMutableArray* titles = [NSMutableArray array];
  NSMutableArray* arguments = [NSMutableArray array];
  
  if ((selectors.count + websites.count) > 6) {
    // condense to one button
    [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsites)]];
    [titles addObject:LocalizedString(@"Websites", @"Title for a button. Needs to be very short. 2-3 words *max*. When tapped, will show the user a list of websites with additional information about the movie")];
    [arguments addObject:[NSNull null]];
  } else {
    // show individual buttons
    for (NSString* name in [websites.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
      [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsite:)]];
      NSString* title = name;
      [titles addObject:title];
      [arguments addObject:[websites objectForKey:name]];
    }
  }
  
  if (selectors.count == 0) {
    self.actionsView = nil;
  } else {
    self.actionsView = [ActionsView viewWithTarget:self
                                         selectors:selectors
                                            titles:titles
                                         arguments:arguments];
    
    [actionsView sizeToFit];
  }
}


+ (UIImage*) posterForPerson:(Person*) person {
//  UIImage* image = [model posterForMovie:movie];
//  
//  if (image != nil) {
//    return image;
//  }
//  
//  return [BoxOfficeStockImages imageNotAvailable];
  return nil;
}


- (void) initializeWebsites {
  NSMutableDictionary* map = [NSMutableDictionary dictionary];
  
  if (![Model model].isInReviewPeriod) {
    NSString* imdbAddress = [[Model model] imdbAddressForPerson:person];
    if (imdbAddress.length > 0) {
      [map setObject:imdbAddress forKey:@"IMDb"];
    }
      
    NSString* wikipediaAddress = [[Model model] wikipediaAddressForPerson:person];
    if (wikipediaAddress.length > 0) {
      [map setObject:wikipediaAddress forKey:@"Wikipedia"];
    }
    
    NSString* netflixAddress = [[Model model] netflixAddressForPerson:person];
    if (netflixAddress.length > 0) {
      [map setObject:netflixAddress forKey:LocalizedString(@"Netflix", nil)];
    }
    
    NSString* rottenTomatoesAddress = [[Model model] rottenTomatoesAddressForPerson:person];
    if (rottenTomatoesAddress.length > 0) {
      [map setObject:rottenTomatoesAddress forKey:@"RottenTomatoes"];
    }
  }
  
  self.websites = map;
}


- (void) updateImage {
  UIImage* image = [PersonDetailsViewController posterForPerson:person];
  // we currently have a poster.  only replace it if we have something better
  if (image != nil && image != [BoxOfficeStockImages imageNotAvailable]) {
    self.posterImage = image;
  }
}


- (void) initializeData {
  self.netflixAccount = [[NetflixAccountCache cache] currentAccount];
  
  [self initializeWebsites];
  [self updateImage];
  [self setupActionsView];
}


- (id) initWithPerson:(Person*) person_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.person = person_;
  }
  
  return self;
}


- (void) setupTitle {
  self.title = person.name;
}


- (void) loadView {
  [super loadView];
  
  self.posterImage = [PersonDetailsViewController posterForPerson:person];
  [self setupTitle];

  // Load the person details as the absolutely highest thing we can do.
  [[PersonCacheUpdater updater] prioritizePerson:person now:YES];
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.person = nil;
  self.websites = nil;
  self.actionsView = nil;
  self.posterImage = nil;
  self.posterImageView = nil;
}


- (void) downloadPosterBackgroundEntryPoint {
  /*
  NSInteger count = [[LargePosterCache cache] posterCountForMovie:movie];
  
  [self performSelectorOnMainThread:@selector(reportPosterCount:)
                         withObject:[NSNumber numberWithInteger:count]
                      waitUntilDone:NO];
  
  [[LargePosterCache cache] downloadFirstPosterForMovie:movie];
   */
  
  
  NSInteger count = 0;
  
  [self performSelectorOnMainThread:@selector(reportPosterCount:)
                         withObject:[NSNumber numberWithInteger:count]
                      waitUntilDone:NO];
  
  [self performSelectorOnMainThread:@selector(reportPoster)
                         withObject:nil
                      waitUntilDone:NO];
}


- (void) reportPosterCount:(NSNumber*) posterNumber {
  NSAssert([NSThread isMainThread], nil);
  if (!visible) { return; }
  posterCount = [posterNumber integerValue];
}


- (void) reportPoster {
  NSAssert([NSThread isMainThread], nil);
  if (!visible) { return; }
  [self minorRefresh];
}


- (void) downloadPoster {
  [ThreadingUtilities backgroundSelector:@selector(downloadPosterBackgroundEntryPoint)
                                onTarget:self
                                    gate:nil
                                  daemon:NO];
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];
  [self downloadPoster];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  
  [self initializeData];
}


- (void) minorRefresh {
  [self majorRefresh];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  // Header
  NSInteger sections = 1;
  
  // Filmography
  sections++;
  
  return sections;
}


- (NSInteger) numberOfRowsInHeaderSection {
  return 1;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 1) {
    return LocalizedString(@"Filmography", nil);
  }
  
  return nil;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  if (section == 0) {
    return [self numberOfRowsInHeaderSection];
  }
  
  if (section == 1) {
    return 0;
  }

  return 0;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
  if (row == 0) {
    self.posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];
    posterImageView.tag = POSTER_TAG;
    posterImageView.delegate = self;
    return [SynopsisCell cellWithSynopsis:person.biography
                                imageView:posterImageView
                              limitLength:NO];
  }
  
  return nil;
}


- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {  
  id cell = [self cellForHeaderRow:row];
  return [cell height:self];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self heightForRowInHeaderSection:indexPath.row];
  }
  
  // show hidden theaters / map theaters
  return tableView.rowHeight;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
  if (section == 0) {
    return actionsView;
  }
  
  return nil;
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
  if (section == 0) {
    CGFloat height = [actionsView height];
    return height;
  }
  
  return -1;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self cellForHeaderRow:indexPath.row];
  }
  
  return nil;
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void) visitWebsite:(NSString*) website {
  [self.commonNavigationController pushBrowser:website animated:YES];
}


- (void) visitWebsites {
  UIActionSheet* actionSheet =
  [[[UIActionSheet alloc] initWithTitle:nil
                               delegate:self
                      cancelButtonTitle:nil
                 destructiveButtonTitle:nil
                      otherButtonTitles:nil] autorelease];
  actionSheet.tag = VISIT_WEBSITES_TAG;
  
  NSArray* keys = [websites.allKeys sortedArrayUsingSelector:@selector(compare:)];
  for (NSString* key in keys) {
    [actionSheet addButtonWithTitle:key];
  }
  
  actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:LocalizedString(@"Cancel", nil)];
  //actionSheet.cancelButtonIndex = keys.count;
  
  [self showActionSheet:actionSheet];
}


- (void) didDismissVisitWebsitesActionSheet:(UIActionSheet*) actionSheet
                            withButtonIndex:(NSInteger) buttonIndex {
  NSString* url = [websites objectForKey:[actionSheet buttonTitleAtIndex:buttonIndex]];
  [self.commonNavigationController pushBrowser:url animated:YES];
}


- (void)            actionSheet:(UIActionSheet*) actionSheet
           clickedButtonAtIndex:(NSInteger) buttonIndex {
  if (buttonIndex == actionSheet.cancelButtonIndex) {
    return;
  }
  if (actionSheet.tag == VISIT_WEBSITES_TAG) {
    [self didDismissVisitWebsitesActionSheet:actionSheet
                             withButtonIndex:buttonIndex];
  }
}


- (void)       tableView:(UITableView*) tableView
      didSelectHeaderRow:(NSInteger) row {
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self tableView:tableView didSelectHeaderRow:indexPath.row];
  }
}


- (void) posterImageViewWasTapped {
  if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    return;
  }
  
  if (posterCount <= 0) {
    return;
  }
  
//  [[OperationQueue operationQueue] performSelector:@selector(downloadAllPostersForMovie:)
//                                          onTarget:[LargePosterCache cache]
//                                        withObject:movie
//                                              gate:nil
//                                          priority:Now];
//  
//  [self.commonNavigationController showPostersView:movie posterCount:posterCount];
}


- (void) imageView:(TappableImageView*) imageView
        wasTouched:(UITouch*) touch
          tapCount:(NSInteger) tapCount {
  if (imageView.tag == POSTER_TAG) {
    [self posterImageViewWasTapped];
  }
}

@end
