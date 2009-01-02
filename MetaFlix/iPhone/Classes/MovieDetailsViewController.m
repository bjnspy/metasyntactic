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

#import "MovieDetailsViewController.h"

#import "AbstractNavigationController.h"
#import "ActionsView.h"
#import "ActivityIndicatorViewWithBackground.h"
#import "AlertUtilities.h"
#import "Application.h"
#import "CollapsedMovieDetailsCell.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "ExpandedMovieDetailsCell.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LargePosterCache.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MovieOverviewCell.h"
#import "MovieShowtimesCell.h"
#import "MutableNetflixCache.h"
#import "NetflixRatingsCell.h"
#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "PosterCache.h"
#import "TappableImageView.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"

@interface MovieDetailsViewController()
@property (retain) Movie* movie;
@property (retain) Movie* netflixMovie;
@property (copy) NSString* trailer;
@property (retain) NSDictionary* websites;
@property (retain) UIView* actionsView;
@property (retain) NSLock* posterDownloadLock;
@property (retain) UIImage* posterImage;
@property (retain) TappableImageView* posterImageView;
@property (retain) ActivityIndicatorViewWithBackground* posterActivityView;
@property (retain) UIButton* bookmarkButton;
@property (retain) NetflixRatingsCell* netflixRatingsCell;
@end


@implementation MovieDetailsViewController

const NSInteger ADD_TO_NETFLIX_TAG = 1;
const NSInteger VISIT_WEBSITES_TAG = 2;

@synthesize movie;
@synthesize netflixMovie;
@synthesize trailer;
@synthesize websites;
@synthesize actionsView;
@synthesize posterActivityView;
@synthesize posterDownloadLock;
@synthesize posterImage;
@synthesize posterImageView;
@synthesize bookmarkButton;
@synthesize netflixRatingsCell;

- (void) dealloc {
    self.movie = nil;
    self.netflixMovie = nil;
    self.trailer = nil;
    self.websites = nil;
    self.actionsView = nil;
    self.posterActivityView = nil;
    self.posterDownloadLock = nil;
    self.posterImage = nil;
    self.posterImageView = nil;
    self.bookmarkButton = nil;
    self.netflixRatingsCell = nil;

    [super dealloc];
}


- (void) setupActionsView {
    NSMutableArray* selectors = [NSMutableArray array];
    NSMutableArray* titles = [NSMutableArray array];
    NSMutableArray* arguments = [NSMutableArray array];

    if (trailer.length > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(playTrailer)]];
        [titles addObject:NSLocalizedString(@"Play trailer", nil)];
        [arguments addObject:[NSNull null]];
    }

    if (netflixMovie != nil && ![self.model.netflixCache isEnqueued:netflixMovie]) {
        [selectors addObject:[NSValue valueWithPointer:@selector(addToQueue)]];
        [titles addObject:NSLocalizedString(@"Add to Netflix", nil)];
        [arguments addObject:[NSNull null]];
    }
    
    if ((selectors.count + websites.count) > 6) {
        // condense to one button
        [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsites)]];
        [titles addObject:NSLocalizedString(@"Websites", nil)];
        [arguments addObject:[NSNull null]];
    } else {
        // show individual buttons
        for (NSString* name in [websites.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
            [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsite:)]];
            [titles addObject:name];
            [arguments addObject:[websites objectForKey:name]];
        }
    }

    if (selectors.count == 0) {
        return;
    }

    self.actionsView = [ActionsView viewWithTarget:self
                                         selectors:selectors
                                            titles:titles
                                         arguments:arguments];
    
    [actionsView sizeToFit];
}


+ (UIImage*) posterForMovie:(Movie*) movie model:(MetaFlixModel*) model {
    UIImage* image = [model posterForMovie:movie];
    if (image == nil) {
        image = [ImageCache imageNotAvailable];
    }
    return image;
}


- (void) initializeWebsites {
    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    NSString* imdbAddress = [self.model imdbAddressForMovie:movie];
    if (imdbAddress.length > 0) {
        [map setObject:imdbAddress forKey:@"IMDb"];
    }

    NSString* amazonAddress = [self.model amazonAddressForMovie:movie];
    if (amazonAddress.length > 0) {
        [map setObject:amazonAddress forKey:@"Amazon"];
    }

    NSString* wikipediaAddress = [self.model wikipediaAddressForMovie:movie];
    if (wikipediaAddress.length > 0) {
        [map setObject:wikipediaAddress forKey:@"Wikipedia"];
    }

    self.websites = map;
}


- (void) updateImage {    
    self.posterImage = [MovieDetailsViewController posterForMovie:movie model:self.model];
    self.posterImageView.image = posterImage;  
}


- (void) initializeData {
    self.netflixMovie = [self.model.netflixCache netflixMovieForMovie:movie];

    NSArray* trailers = [self.model trailersForMovie:movie];
    if (trailers.count > 0) {
        self.trailer = [trailers objectAtIndex:0];
    }

    [self initializeWebsites];
    [self updateImage];
    [self setupActionsView];
}


- (void) setupPosterView {
    self.posterImage = [MovieDetailsViewController posterForMovie:movie model:self.model];
    self.posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];
    posterImageView.delegate = self;
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithNavigationController:controller]) {
        self.movie = movie_;
        self.posterDownloadLock = [[[NSRecursiveLock alloc] init] autorelease];

        // Only want to do this once.
        self.posterActivityView = [[[ActivityIndicatorViewWithBackground alloc] init] autorelease];
        [posterActivityView startAnimating];
        [posterActivityView sizeToFit];
    }

    return self;
}


- (BOOL) isBookmarked {
    return [self.model isBookmarked:movie];
}


- (void) addBookmark {
    [self.model addBookmark:movie];
}


- (void) removeBookmark {
    [self.model removeBookmark:movie];
}


- (void) setBookmarkImage {
    self.bookmarkButton.selected = [self isBookmarked];
}


- (void) switchBookmark:(id) sender {
    if ([self isBookmarked]) {
        [self removeBookmark];
    } else {
        [self addBookmark];
    }

    [self setBookmarkImage];
}


- (void) initializeBookmarkButton {
    self.bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookmarkButton setImage:[ImageCache emptyStarImage] forState:UIControlStateNormal];
    [bookmarkButton setImage:[ImageCache filledStarImage] forState:UIControlStateSelected];

    [bookmarkButton addTarget:self action:@selector(switchBookmark:) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = bookmarkButton.frame;
    frame.size = [ImageCache emptyStarImage].size;
    frame.size.width += 10;
    frame.size.height += 10;
    bookmarkButton.frame = frame;

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bookmarkButton] autorelease];
    [self setBookmarkImage];
}


- (void) setupTitle {
    if (readonlyMode) {
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = NSLocalizedString(@"Please Wait", nil);

        self.navigationItem.titleView = label;
    } else {
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = movie.displayTitle;

        self.title = movie.displayTitle;
        self.navigationItem.titleView = label;
    }
}


- (void) setupButtons {
    if (readonlyMode) {
        UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect frame = activityIndicatorView.frame;
        frame.size.width += 4;
        [activityIndicatorView startAnimating];

        UIView* activityView = [[UIView alloc] initWithFrame:frame];
        [activityView addSubview:activityIndicatorView];

        UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];
        [self.navigationItem setRightBarButtonItem:right animated:YES];
        [self.navigationItem setHidesBackButton:YES animated:YES];
    } else {
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self initializeBookmarkButton];
    }
}


- (void) loadView {
    [super loadView];

    [self setupTitle];
    [self setupPosterView];
    [self setupButtons];

    [self.model prioritizeMovie:movie];
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.dvd = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailer = nil;
    self.reviewsArray = nil;
    self.websites = nil;
    self.hiddenTheaterCount = 0;
    self.actionsView = nil;
    self.posterImage = nil;
    self.posterImageView = nil;
    self.posterActivityView = nil;

    [super didReceiveMemoryWarning];
}


- (void) downloadPoster {
    [self.model.largePosterCache downloadFirstPosterForMovie:movie];
    NSInteger posterCount_ = [self.model.largePosterCache posterCountForMovie:movie];

    [self performSelectorOnMainThread:@selector(reportPoster:)
                           withObject:[NSNumber numberWithInt:posterCount_]
                        waitUntilDone:NO];
}


- (void) reportPoster:(NSNumber*) posterNumber {
    NSAssert([NSThread isMainThread], nil);
    if (shutdown) { return; }
    posterCount = [posterNumber intValue];
    [posterActivityView stopAnimating];
    [self minorRefresh];
}


- (void) startup {
    shutdown = NO;

    [ThreadingUtilities backgroundSelector:@selector(downloadPoster)
                                  onTarget:self
                                  argument:posterDownloadLock
                                      gate:nil
                                   visible:NO];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self startup];
    [self majorRefresh];
}


- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}


- (void) shutdown {
    shutdown = YES;
    [posterActivityView stopAnimating];
}


- (void) viewWillDisappear:(BOOL) animated {
    [self shutdown];
    [self removeNotifications];
}


- (void) minorRefresh {
    [self majorRefresh];
}


- (void) majorRefresh {
    if (readonlyMode) {
        return;
    }

    [self initializeData];
    [netflixRatingsCell refresh];
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return 3;
}


- (UITableViewCell*) createNetflixRatingsCell {
    if (netflixRatingsCell == nil) {
        self.netflixRatingsCell =
        [[[NetflixRatingsCell alloc] initWithFrame:CGRectZero
                                             model:self.model
                                             movie:movie] autorelease];
    }

    return netflixRatingsCell;
}


- (BOOL) hasNetflixRating {
    return [self.model.netflixCache netflixRatingForMovie:movie].length > 0;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell cellWithMovie:movie
                                          model:self.model
                                          frame:[UIScreen mainScreen].applicationFrame
                                    posterImage:posterImage
                                posterImageView:posterImageView
                                   activityView:posterActivityView];
    }

    if (row == 1) {
        if ([self hasNetflixRating]) {
            return [self createNetflixRatingsCell];
        } else {
            return [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        }
    }

    if (expandedDetails) {
        return [[[ExpandedMovieDetailsCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                                          model:self.model
                                                          movie:movie] autorelease];
    } else {
        return [[[CollapsedMovieDetailsCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                                           model:self.model
                                                           movie:movie] autorelease];
    }
}


- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell heightForMovie:movie model:self.model];
    }

    if (row == 1) {
        if ([self hasNetflixRating]) {
            return self.tableView.rowHeight;
        } else {
            return 0;
        }
    }

    AbstractMovieDetailsCell* cell = (AbstractMovieDetailsCell*)[self cellForHeaderRow:row];
    return [cell height:self.tableView];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }

    // show hidden theaters
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

        return height + 8;
    }

    return -1;
}


- (UITableViewCell*) showHiddenTheatersCell {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    cell.textAlignment = UITextAlignmentCenter;

    if (self.hiddenTheaterCount == 1) {
        cell.text = NSLocalizedString(@"Show 1 hidden theater", @"We hide theaters if they are too far away.  But we provide this button to let the user 'unhide' in case it's the only theater showing a movie they care about.");
    } else {
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d hidden theaters", @"We hide theaters if they are too far away.  But we provide this button to let the user 'unhide' in case it's the only theater showing a movie they care about."),
                     self.hiddenTheaterCount];
    }

    cell.textColor = [ColorCache commandColor];
    cell.font = [UIFont boldSystemFontOfSize:14];

    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [self cellForHeaderRow:indexPath.row];
}


- (void) didSelectShowHiddenTheaters {
    NSIndexPath* startPath = self.tableView.indexPathForSelectedRow;
    [self.tableView deselectRowAtIndexPath:startPath animated:NO];

    [self majorRefresh];

    // this animates showing the theaters.  but it's unfortunately too slow
    /*
     NSInteger currentTheaterCount = self.theatersArray.count;
     filterTheatersByDistance = NO;

     [self initializeData];

     NSInteger newTheaterCount = self.theatersArray.count;

     if (currentTheaterCount >= newTheaterCount) {
     return;
     }

     NSInteger startSection = startPath.section;
     [self.tableView beginUpdates];
     {
     [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:startSection] withRowAnimation:UITableViewRowAnimationBottom];

     NSMutableIndexSet* sectionsToAdd = [NSMutableIndexSet indexSet];

     for (int i = 0; i < (newTheaterCount - currentTheaterCount); i++) {
     [sectionsToAdd addIndex:startSection + i];
     }

     [self.tableView insertSections:sectionsToAdd withRowAnimation:UITableViewRowAnimationBottom];
     }
     [self.tableView endUpdates];

     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:startSection]
     atScrollPosition:UITableViewScrollPositionMiddle
     animated:YES];
     */
}


- (void) playTrailer {
    NSString* urlString = trailer;
    MPMoviePlayerController* moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlString]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedPlaying:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];

    [moviePlayer play];
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
    [self removeNotifications];

    MPMoviePlayerController* moviePlayer = notification.object;
    [moviePlayer stop];
    [moviePlayer autorelease];
}


- (void) readReviews {
    [navigationController pushReviews:movie animated:YES];
}


- (void) visitWebsite:(NSString*) website {
    [navigationController pushBrowser:website animated:YES];
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

    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = keys.count;

    [actionSheet showInView:[MetaFlixAppDelegate window]];
}


- (void) enterReadonlyMode {
    if (readonlyMode) {
        return;
    }
    readonlyMode = YES;
    [self setupTitle];
    [self setupButtons];
}


- (void) exitReadonlyMode {
    readonlyMode = NO;
    [self setupTitle];
    [self setupButtons];
}


- (void) addToQueue:(BOOL) instant {
    [self enterReadonlyMode];

    Queue* queue;
    if (instant) {
        queue = [self.model.netflixCache queueForKey:[NetflixCache instantQueueKey]];
    } else {
        queue = [self.model.netflixCache queueForKey:[NetflixCache dvdQueueKey]];
    }

    [self.model.netflixCache updateQueue:queue byAddingMovie:netflixMovie delegate:self];
}


- (void) addSucceeded {
    [self exitReadonlyMode];
    [self majorRefresh];
}


- (void) addFailedWithError:(NSString*) error {
    [AlertUtilities showOkAlert:error];
    [self exitReadonlyMode];
    [self majorRefresh];
}


- (void) addToQueue {
    if (readonlyMode) {
        return;
    }

    NSArray* formats = [self.model.netflixCache formatsForMovie:netflixMovie];
    if (formats.count >= 2 && [formats containsObject:@"instant"]) {
        UIActionSheet* actionSheet =
        [[[UIActionSheet alloc] initWithTitle:nil
                                     delegate:self
                            cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                       destructiveButtonTitle:nil
                            otherButtonTitles:NSLocalizedString(@"DVD/Blu-ray Queue", nil), NSLocalizedString(@"Instant Queue", nil), nil] autorelease];
        actionSheet.tag = ADD_TO_NETFLIX_TAG;

        [actionSheet showInView:[MetaFlixAppDelegate window]];
    } else {
        [self addToQueue:NO];
    }
}


- (void) didDismissAddToNetflixActionSheet:(UIActionSheet*) actionSheet
                           withButtonIndex:(NSInteger) buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self addToQueue:[@"instant" isEqual:[actionSheet buttonTitleAtIndex:buttonIndex]]];
    }
}


- (void) didDismissVisitWebsitesActionSheet:(UIActionSheet*) actionSheet
                            withButtonIndex:(NSInteger) buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString* url = [websites objectForKey:[actionSheet buttonTitleAtIndex:buttonIndex]];
        [navigationController pushBrowser:url animated:YES];
    }
}


- (void)            actionSheet:(UIActionSheet*) actionSheet
      didDismissWithButtonIndex:(NSInteger) buttonIndex {
    if (actionSheet.tag == ADD_TO_NETFLIX_TAG) {
        [self didDismissAddToNetflixActionSheet:actionSheet
                                withButtonIndex:buttonIndex];
    } else {
        [self didDismissVisitWebsitesActionSheet:actionSheet
                                 withButtonIndex:buttonIndex];
    }
}


- (void)       tableView:(UITableView*) tableView
      didSelectHeaderRow:(NSInteger) row {
    if (row == 3) {
        expandedDetails = !expandedDetails;

        NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
        [tableView beginUpdates];
        {
            NSArray* paths = [NSArray arrayWithObject:path];
            [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView endUpdates];

        //[tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        // hack: when shrinking the details pane, the 'actions view' can
        // sometimes go missing.  To prevent that, we refresh explicitly.
        if (!expandedDetails) {
            [self.tableView reloadData];
        }
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self tableView:tableView didSelectHeaderRow:indexPath.row];
    }
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryNone;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) imageView:(TappableImageView*) imageView
         wasTapped:(NSInteger) tapCount {
    if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return;
    }

    if (posterCount == 0) {
        return;
    }

    [ThreadingUtilities backgroundSelector:@selector(downloadAllPostersForMovie:)
                                  onTarget:self.model.largePosterCache
                                  argument:movie
                                      gate:posterDownloadLock
                                   visible:NO];

    [navigationController showPostersView:movie posterCount:posterCount];
}

@end