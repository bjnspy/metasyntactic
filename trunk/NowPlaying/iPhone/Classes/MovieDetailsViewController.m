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

#import "ActionsView.h"
#import "ActivityIndicatorViewWithBackground.h"
#import "Application.h"
#import "CollapsedMovieDetailsCell.h"
#import "ColorCache.h"
#import "DVD.h"
#import "DVDCache.h"
#import "DateUtilities.h"
#import "ExpandedMovieDetailsCell.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LargePosterCache.h"
#import "Movie.h"
#import "MovieOverviewCell.h"
#import "MovieShowtimesCell.h"
#import "MoviesNavigationController.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PosterCache.h"
#import "PostersViewController.h"
#import "TappableImageView.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"

@interface MovieDetailsViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) DVD* dvd;
@property (retain) NSMutableArray* theatersArray;
@property (retain) NSMutableArray* showtimesArray;
@property (copy) NSString* trailer;
@property (retain) NSArray* reviewsArray;
@property (copy) NSString* imdbAddress;
@property (retain) UIView* actionsView;
@property NSInteger hiddenTheaterCount;
@property (retain) NSLock* posterDownloadLock;
@property (retain) UIImage* posterImage;
@property (retain) TappableImageView* posterImageView;
@property (retain) ActivityIndicatorViewWithBackground* posterActivityView;
@end


@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize dvd;
@synthesize theatersArray;
@synthesize showtimesArray;
@synthesize trailer;
@synthesize reviewsArray;
@synthesize imdbAddress;
@synthesize actionsView;
@synthesize hiddenTheaterCount;
@synthesize posterActivityView;
@synthesize posterDownloadLock;
@synthesize posterImage;
@synthesize posterImageView;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.dvd = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailer = nil;
    self.reviewsArray = nil;
    self.imdbAddress = nil;
    self.actionsView = nil;
    self.hiddenTheaterCount = 0;
    self.posterActivityView = nil;
    self.posterDownloadLock = nil;
    self.posterImage = nil;
    self.posterImageView = nil;

    [super dealloc];
}


- (void) orderTheaters {
    [theatersArray sortUsingFunction:compareTheatersByDistance
                             context:self.model.theaterDistanceMap];

    NSMutableArray* favorites = [NSMutableArray array];
    NSMutableArray* nonFavorites = [NSMutableArray array];

    for (Theater* theater in theatersArray) {
        if ([self.model isFavoriteTheater:theater]) {
            [favorites addObject:theater];
        } else {
            [nonFavorites addObject:theater];
        }
    }

    NSMutableArray* result = [NSMutableArray array];
    [result addObjectsFromArray:favorites];
    [result addObjectsFromArray:nonFavorites];

    self.theatersArray = result;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (void) setupActionsView {
    NSMutableArray* selectors = [NSMutableArray array];
    NSMutableArray* titles = [NSMutableArray array];

    if (trailer.length > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(playTrailer)]];
        [titles addObject:NSLocalizedString(@"Play trailer", nil)];
    }

    if (reviewsArray.count > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(readReviews)]];
        [titles addObject:NSLocalizedString(@"Read reviews", nil)];
    }

    if (imdbAddress.length > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(visitIMDb)]];
        [titles addObject:NSLocalizedString(@"Visit IMDb", nil)];
    }

    if (theatersArray.count > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(emailListings)]];
        [titles addObject:NSLocalizedString(@"E-mail listings", nil)];
    }

    if (dvd != nil) {
        [selectors addObject:[NSValue valueWithPointer:@selector(visitWebsite)]];
        [titles addObject:NSLocalizedString(@"Website", nil)];
    }

    if (selectors.count == 0) {
        return;
    }

    self.actionsView = [ActionsView viewWithTarget:self selectors:selectors titles:titles];
    [actionsView sizeToFit];
}


+ (UIImage*) posterForMovie:(Movie*) movie model:(NowPlayingModel*) model {
    UIImage* image = [model posterForMovie:movie];
    if (image == nil) {
        image = [ImageCache imageNotAvailable];
    }
    return image;
}


- (void) initializeData {
    NSArray* trailers = [self.model trailersForMovie:movie];
    if (trailers.count > 0) {
        self.trailer = [trailers objectAtIndex:0];
    }

    if (!self.model.noScores) {
        self.reviewsArray = [NSArray arrayWithArray:[self.model reviewsForMovie:movie]];
    }

    NSArray* theatersShowingMovie = [self.model theatersShowingMovie:movie];

    if (filterTheatersByDistance) {
        self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:theatersShowingMovie]];
        self.hiddenTheaterCount = theatersShowingMovie.count - theatersArray.count;
    } else {
        self.theatersArray = [NSMutableArray arrayWithArray:theatersShowingMovie];
        self.hiddenTheaterCount = 0;
    }

    [self orderTheaters];

    self.showtimesArray = [NSMutableArray array];

    for (Theater* theater in theatersArray) {
        [self.showtimesArray addObject:[self.model moviePerformances:movie forTheater:theater]];
    }

    self.imdbAddress = [self.model imdbAddressForMovie:movie];

    self.posterImage = [MovieDetailsViewController posterForMovie:movie model:self.model];
    self.posterImageView.image = posterImage;

    [self setupActionsView];
}


- (void) setupPosterView {
    self.posterImage = [MovieDetailsViewController posterForMovie:movie model:self.model];
    self.posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];
    posterImageView.delegate = self;
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.movie = movie_;
        self.posterDownloadLock = [[[NSRecursiveLock alloc] init] autorelease];

        // Only want to do this once.
        self.posterActivityView = [[[ActivityIndicatorViewWithBackground alloc] init] autorelease];
        [posterActivityView startAnimating];
        [posterActivityView sizeToFit];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    self.dvd = [self.model dvdDetailsForMovie:movie];

    filterTheatersByDistance = YES;

    UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
    label.text = movie.displayTitle;

    self.title = movie.displayTitle;
    self.navigationItem.titleView = label;

    [self setupPosterView];
    [self.model prioritizeMovie:movie];
}


- (void) viewDidAppear:(BOOL)animated {
    visible = YES;
    [self.model saveNavigationStack:self.navigationController];
}


- (void) viewDidDisappear:(BOOL)animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (/*navigationController.visible ||*/ visible) {
        return;
    }

    self.dvd = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailer = nil;
    self.reviewsArray = nil;
    self.imdbAddress = nil;
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


- (void) reportPoster:(NSNumber*) posterCount_ {
    if (shutdown) { return; }
    posterCount = [posterCount_ intValue];
    [posterActivityView stopAnimating];
}


- (void) startup {
    shutdown = NO;

    [ThreadingUtilities performSelector:@selector(downloadPoster)
                               onTarget:self
               inBackgroundWithArgument:posterDownloadLock
                                   gate:nil visible:NO];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];

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
    [self initializeData];
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    // Header
    NSInteger sections = 1;

    // theaters
    sections += theatersArray.count;

    // show hidden theaters
    if (hiddenTheaterCount > 0) {
        sections += 1;
    }

    return sections;
}


- (NSInteger) numberOfRowsInHeaderSection {
    if (dvd == nil) {
        return 2;
    } else {
        return 3;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 1 && theatersArray.count > 0) {
        if ([DateUtilities isToday:self.model.searchDate]) {
            return NSLocalizedString(@"Today", nil);
        } else {
            return [DateUtilities formatFullDate:self.model.searchDate];
        }
    }
    
    return nil;
}


- (NSInteger) getTheaterIndex:(NSInteger) section {
    return section - 1;
}


- (NSInteger) isTheaterSection:(NSInteger) section {
    NSInteger theaterIndex = [self getTheaterIndex:section];
    return theaterIndex >= 0 && theaterIndex < theatersArray.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }

    if ([self isTheaterSection:section]) {
        return 2;
    }

    // show hidden theaters
    return 1;
}


- (UITableViewCell*) createDvdDetailsCell {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    if ([@"1" isEqual:dvd.discs]) {
        label.text = [NSString stringWithFormat:NSLocalizedString(@"$%@. %@ - 1 disc.", @"$19.99.  Widescreen DVD - 1 disc."), dvd.price, dvd.format];
    } else {
        label.text = [NSString stringWithFormat:NSLocalizedString(@"$%@. %@ - %@ discs.", @"$19.99.  Widescreen DVD - 2 discs."), dvd.price, dvd.format, dvd.discs];
    }
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.height = self.tableView.rowHeight - 16;
    frame.size.width = 300;
    label.frame = frame;

    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:label];

    return cell;
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

    if (row == 1 && dvd != nil) {
        return [self createDvdDetailsCell];
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

    if (row == 1 && dvd != nil) {
        return self.tableView.rowHeight - 14;
    }

    AbstractMovieDetailsCell* cell = (AbstractMovieDetailsCell*)[self cellForHeaderRow:row];
    return [cell height:self.tableView];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        if (indexPath.row == 0) {
            return tableView.rowHeight;
        } else {
            NSInteger theaterIndex = [self getTheaterIndex:indexPath.section];
            Theater* theater = [theatersArray objectAtIndex:theaterIndex];

            return [MovieShowtimesCell heightForShowtimes:[showtimesArray objectAtIndex:theaterIndex]
                                                    stale:[self.model isStale:theater]
                                            useSmallFonts:self.model.useSmallFonts] + 18;
        }
    }

    // show hidden theaters
    return tableView.rowHeight;
}


- (UITableViewCell*) cellForTheaterSection:(NSInteger) theaterIndex
                                       row:(NSInteger) row {
    if (row == 0) {
        static NSString* reuseIdentifier = @"MovieDetailsTheaterCellIdentifier";
        id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[TheaterNameCell alloc] initWithFrame:CGRectZero
                                           reuseIdentifier:reuseIdentifier
                                                     model:self.model] autorelease];
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        [cell setTheater:theater];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"MovieDetailsShowtimesCellIdentifier";
        id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                              reuseIdentifier:reuseIdentifier] autorelease];
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        BOOL stale = [self.model isStale:theater];
        [cell setStale:stale];

        [cell setShowtimes:[showtimesArray objectAtIndex:theaterIndex]
             useSmallFonts:self.model.useSmallFonts];

        return cell;
    }
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
    if (section == 0) {
        return actionsView;
    }

    return nil;
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat height = [actionsView height];

        if (theatersArray.count == 0) {
            return height + 8;
        } else {
            return height + 1;
        }
    }

    return -1;
}


- (NSString*)       tableView:(UITableView*) tableView
       titleForFooterInSection:(NSInteger) section {
    if (![self isTheaterSection:section]) {
        return nil;
    }

    Theater* theater = [theatersArray objectAtIndex:[self getTheaterIndex:section]];
    if (![self.model isStale:theater]) {
        return nil;
    }

    return [self.model showtimesRetrievedOnString:theater];
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
    if (indexPath.section == 0) {
        return [self cellForHeaderRow:indexPath.row];
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        return [self cellForTheaterSection:[self getTheaterIndex:indexPath.section] row:indexPath.row];
    }

    return [self showHiddenTheatersCell];
}


- (void) didSelectShowHiddenTheaters {
    NSIndexPath* startPath = self.tableView.indexPathForSelectedRow;
    [self.tableView deselectRowAtIndexPath:startPath animated:NO];

    filterTheatersByDistance = NO;
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
    [navigationController pushReviewsView:movie animated:YES];
}


- (void) visitIMDb {
    [Application openBrowser:imdbAddress];
}


- (void) visitWebsite {
    [Application openBrowser:dvd.url];
}


- (void) emailListings {
    NSString* movieAndDate = [NSString stringWithFormat:@"%@ - %@",
                              movie.canonicalTitle,
                              [DateUtilities formatFullDate:self.model.searchDate]];
    NSMutableString* body = [NSMutableString string];

    for (int i = 0; i < theatersArray.count; i++) {
        if (i != 0) {
            [body appendString:@"\n\n"];
        }

        Theater* theater = [theatersArray objectAtIndex:i];
        NSArray* performances = [showtimesArray objectAtIndex:i];

        [body appendString:theater.name];
        [body appendString:@"\n"];
        [body appendString:@"<a href=\""];
        [body appendString:theater.mapUrl];
        [body appendString:@"\">"];
        [body appendString:[self.model simpleAddressForTheater:theater]];
        [body appendString:@"</a>"];

        [body appendString:@"\n"];
        [body appendString:[Utilities generateShowtimeLinks:self.model
                                                      movie:movie
                                                    theater:theater
                                               performances:performances]];
    }

    NSString* url = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                     [Utilities stringByAddingPercentEscapes:movieAndDate],
                     [Utilities stringByAddingPercentEscapes:body]];

    [Application openBrowser:url];
}


- (void) pushTicketsView:(Theater*) theater
                animated:(BOOL) animated {
    [navigationController pushTicketsView:movie
                                  theater:theater
                                    title:theater.name
                                 animated:animated];
}


- (void)       tableView:(UITableView*) tableView
      didSelectHeaderRow:(NSInteger) row {
    int expandableRow;
    if (dvd == nil) {
        expandableRow = 1;
    } else {
        expandableRow = 2;
    }

    if (row == expandableRow) {
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
        return;
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        Theater* theater = [theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];

        if (indexPath.row == 0) {
            [navigationController pushTheaterDetails:theater animated:YES];
        } else {
            [self pushTicketsView:theater animated:YES];
        }
        return;
    }

    [self didSelectShowHiddenTheaters];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;

    if (section == 0) {
        return UITableViewCellAccessoryNone;
    }

    if ([self isTheaterSection:section]) {
        // theater section
        return UITableViewCellAccessoryDisclosureIndicator;
    }

    // show hidden theaters
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

    [ThreadingUtilities performSelector:@selector(downloadAllPostersForMovie:)
                               onTarget:self.model.largePosterCache
               inBackgroundWithArgument:movie
                                   gate:posterDownloadLock
                                visible:NO];

    [navigationController showPostersView:movie posterCount:posterCount];
}

@end