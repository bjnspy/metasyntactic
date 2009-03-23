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
#import "AlertUtilities.h"
#import "AppDelegate.h"
#import "Application.h"
#import "CollapsedMovieDetailsCell.h"
#import "ColorCache.h"
#import "DVD.h"
#import "DateUtilities.h"
#import "ExpandedMovieDetailsCell.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LargePosterCache.h"
#import "LookupResult.h"
#import "Model.h"
#import "Movie.h"
#import "MovieOverviewCell.h"
#import "MovieShowtimesCell.h"
#import "MoviesNavigationController.h"
#import "MutableNetflixCache.h"
#import "NetflixRatingsCell.h"
#import "NetflixStatusCell.h"
#import "OperationQueue.h"
#import "PosterCache.h"
#import "Score.h"
#import "Status.h"
#import "StringUtilities.h"
#import "TappableImageView.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"
#import "UpcomingCache.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"

@interface MovieDetailsViewController()
@property (retain) Movie* movie;
@property (retain) DVD* dvd;
@property (retain) Movie* netflixMovie;
@property (retain) NSArray* netflixStatusCells;
@property (retain) NetflixRatingsCell* netflixRatingsCell;
@property (retain) NSMutableArray* theatersArray;
@property (retain) NSMutableArray* showtimesArray;
@property (copy) NSString* trailer;
@property (retain) NSArray* reviewsArray;
@property (retain) NSDictionary* websites;
@property (retain) ActionsView* actionsView;
@property NSInteger hiddenTheaterCount;
@property (retain) UIImage* posterImage;
@property (retain) TappableImageView* posterImageView;
@property (retain) ActivityIndicatorViewWithBackground* posterActivityView;
@property (retain) UIButton* bookmarkButton;
@end


@implementation MovieDetailsViewController

const NSInteger ADD_TO_NETFLIX_DISC_QUEUE_TAG = 1;
const NSInteger ADD_TO_NETFLIX_DISC_OR_INSTANT_QUEUE_TAG = 2;
const NSInteger ADD_TO_NETFLIX_INSTANT_QUEUE_TAG = 3;
const NSInteger VISIT_WEBSITES_TAG = 4;

const NSInteger POSTER_TAG = -1;

@synthesize movie;
@synthesize dvd;
@synthesize netflixMovie;
@synthesize netflixStatusCells;
@synthesize netflixRatingsCell;
@synthesize theatersArray;
@synthesize showtimesArray;
@synthesize trailer;
@synthesize reviewsArray;
@synthesize websites;
@synthesize actionsView;
@synthesize hiddenTheaterCount;
@synthesize posterActivityView;
@synthesize posterImage;
@synthesize posterImageView;
@synthesize bookmarkButton;

- (void) dealloc {
    self.movie = nil;
    self.dvd = nil;
    self.netflixMovie = nil;
    self.netflixStatusCells = nil;
    self.netflixRatingsCell = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailer = nil;
    self.reviewsArray = nil;
    self.websites = nil;
    self.actionsView = nil;
    self.hiddenTheaterCount = 0;
    self.posterActivityView = nil;
    self.posterImage = nil;
    self.posterImageView = nil;
    self.bookmarkButton = nil;

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


- (BOOL) isUpcomingMovie {
    for (Movie* upcomingMovie in self.model.upcomingCache.movies) {
        if (upcomingMovie == movie) {
            return YES;
        }
    }

    return NO;
}


- (BOOL) isDVD {
    return dvd != nil;
}


- (BOOL) isNetflix {
    return movie.isNetflix;
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

    if (reviewsArray.count > 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(readReviews)]];
        [titles addObject:NSLocalizedString(@"Read reviews", nil)];
        [arguments addObject:[NSNull null]];
    }

    if (theatersArray.count > 0 && [Application canSendMail]) {
        [selectors addObject:[NSValue valueWithPointer:@selector(emailListings)]];
        [titles addObject:NSLocalizedString(@"E-mail listings", nil)];
        [arguments addObject:[NSNull null]];
    }

    if (netflixMovie != nil && netflixStatusCells.count == 0) {
        [selectors addObject:[NSValue valueWithPointer:@selector(addToQueue)]];
        [titles addObject:NSLocalizedString(@"Add to Netflix", nil)];
        [arguments addObject:[NSNull null]];
    }

    if (![self isUpcomingMovie] && ![self isDVD] && ![self isNetflix]) {
        [selectors addObject:[NSValue valueWithPointer:@selector(changeDate)]];
        [titles addObject:NSLocalizedString(@"Change date", nil)];
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


+ (UIImage*) posterForMovie:(Movie*) movie model:(Model*) model {
    UIImage* image = [model posterForMovie:movie];
    CGSize size = image.size;

    if (size.height > 0 && size.width > 0) {
        return image;
    }

    return [ImageCache imageNotAvailable];
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

    Score* score = [self.model rottenTomatoesScoreForMovie:movie];
    if (score.identifier.length > 0) {
        [map setObject:score.identifier forKey:@"RottenTomatoes"];
    }

    score = [self.model metacriticScoreForMovie:movie];
    if (score.identifier.length > 0) {
        [map setObject:score.identifier forKey:@"Metacritic"];
    }

    if (dvd != nil) {
        [map setObject:dvd.url forKey:@"VideoETA"];
    }
    self.websites = map;
}


- (void) updateImage {
    UIImage* image = [MovieDetailsViewController posterForMovie:movie model:self.model];
    if (posterImage != nil) {
        // we currently have a poster.  only replace it if we have something better
        if (image != nil && image != [ImageCache imageNotAvailable]) {
            self.posterImage = image;
        }
    }
    self.posterImageView.image = posterImage;
}


- (void) initializeNetflixStatusCells {
    NSArray* statuses = [self.model.netflixCache statusesForMovie:netflixMovie];

    NSMutableArray* cells = [NSMutableArray array];
    for (NSInteger i = 0; i < statuses.count; i++) {
        Status* status = [statuses objectAtIndex:i];
        NetflixStatusCell* cell = [[[NetflixStatusCell alloc] initWithStatus:status] autorelease];
        cell.moveImageView.delegate = self;
        cell.deleteImageView.delegate = self;

        cell.moveImageView.tag = 2 * i;
        cell.deleteImageView.tag = 2 * i + 1;

        [cells addObject:cell];
    }

    // try to workaround the crash with released cells
    [netflixStatusCells retain];
    [netflixStatusCells performSelectorOnMainThread:@selector(autorelease) withObject:nil waitUntilDone:NO];

    self.netflixStatusCells = cells;
}


- (void) initializeData {
    self.netflixMovie = [self.model.netflixCache netflixMovieForMovie:movie];
    [self initializeNetflixStatusCells];

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

    [self initializeWebsites];
    [self updateImage];
    [self setupActionsView];
}


- (void) setupPosterView {
    self.posterImage = [MovieDetailsViewController posterForMovie:movie model:self.model];
    self.posterImageView = [[[TappableImageView alloc] initWithImage:posterImage] autorelease];
    posterImageView.tag = POSTER_TAG;
    posterImageView.delegate = self;
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped navigationController:navigationController_]) {
        self.movie = movie_;

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

    self.dvd = [self.model dvdDetailsForMovie:movie];

    filterTheatersByDistance = YES;

    [self setupTitle];
    [self setupPosterView];
    [self setupButtons];

    [self.model prioritizeMovie:movie];
}


- (void) didReceiveMemoryWarning {
    if (readonlyMode) {
        return;
    }

    [super didReceiveMemoryWarning];
}


- (void) didReceiveMemoryWarningWorker {
    [super didReceiveMemoryWarningWorker];
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
}


- (void) downloadPosterBackgroundEntryPoint {
    [self.model.largePosterCache downloadFirstPosterForMovie:movie];
    NSInteger posterCount_ = [self.model.largePosterCache posterCountForMovie:movie];

    [self performSelectorOnMainThread:@selector(reportPoster:)
                           withObject:[NSNumber numberWithInt:posterCount_]
                        waitUntilDone:NO];
}


- (void) reportPoster:(NSNumber*) posterNumber {
    NSAssert([NSThread isMainThread], nil);
    if (!visible) { return; }
    posterCount = [posterNumber intValue];
    [posterActivityView stopAnimating];
    [self minorRefresh];
}


- (void) downloadPoster {
    if (posterLoaded) {
        return;
    }
    posterLoaded = YES;

    [[AppDelegate operationQueue] performSelector:@selector(downloadPosterBackgroundEntryPoint)
                                  onTarget:self
                                      gate:nil
                                   priority:High];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];

    [self downloadPoster];
    [self majorRefresh];
}


- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}


- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    [posterActivityView stopAnimating];

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
    [self reloadTableViewData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    // Header
    NSInteger sections = 1;

    // Netflix
    sections += 1;

    // theaters
    sections += theatersArray.count;

    // show hidden theaters
    if (hiddenTheaterCount > 0) {
        sections += 1;
    }

    return sections;
}


- (NSInteger) numberOfRowsInHeaderSection {
    return 3;
}


- (BOOL) hasNetflixRating {
    return
    netflixMovie != nil &&
    [self.model.netflixCache netflixRatingForMovie:netflixMovie].length > 0;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 1) {
        if ([self hasNetflixRating] || netflixStatusCells.count > 0) {
            return NSLocalizedString(@"Netflix", nil);
        }
    } else if (section == 2 && theatersArray.count > 0) {
        if (self.model.isSearchDateToday) {
            //[DateUtilities isToday:self.model.searchDate]) {
            return NSLocalizedString(@"Today", nil);
        } else {
            return [DateUtilities formatFullDate:self.model.searchDate];
        }
    }

    return nil;
}


- (NSInteger) getTheaterIndex:(NSInteger) section {
    return section - 2;
}


- (NSInteger) isTheaterSection:(NSInteger) section {
    NSInteger theaterIndex = [self getTheaterIndex:section];
    return theaterIndex >= 0 && theaterIndex < theatersArray.count;
}


- (NSInteger) numberOfRowsInNetflixSection {
    if (netflixMovie != nil) {
        return 1 + netflixStatusCells.count;
    }

    return 0;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }

    if (section == 1) {
        return [self numberOfRowsInNetflixSection];
    }

    if ([self isTheaterSection:section]) {
        return 2;
    }

    // show hidden theaters
    return 1;
}


- (UITableViewCell*) createDvdDetailsCell {
    if (dvd == nil) {
        return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    }

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

    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:label];

    return cell;
}


- (UITableViewCell*) createNetflixRatingsCell {
    if (netflixRatingsCell == nil) {
        self.netflixRatingsCell =
        [[[NetflixRatingsCell alloc] initWithModel:self.model
                                             movie:netflixMovie] autorelease];
    }

    return netflixRatingsCell;
}


- (UITableViewCell*) cellForNetflixRow:(NSInteger) row {
    if (row == 0) {
        return [self createNetflixRatingsCell];
    } else {
        return [netflixStatusCells objectAtIndex:row - 1];
    }
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell cellWithMovie:movie
                                          model:self.model
                                    posterImage:posterImage
                                posterImageView:posterImageView
                                   activityView:posterActivityView];
    }

    if (row == 1) {
        return [self createDvdDetailsCell];
    }

    if (expandedDetails) {
        return [[[ExpandedMovieDetailsCell alloc] initWithModel:self.model
                                                          movie:movie] autorelease];
    } else {
        return [[[CollapsedMovieDetailsCell alloc] initWithModel:self.model
                                                           movie:movie] autorelease];
    }
}


- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell heightForMovie:movie model:self.model];
    }

    if (row == 1) {
        if (dvd != nil) {
            return self.tableView.rowHeight - 14;
        } else {
            return 0;
        }
    }

    AbstractMovieDetailsCell* cell = (AbstractMovieDetailsCell*)[self cellForHeaderRow:row];
    return [cell height:self.tableView];
}


- (CGFloat) heightForNetflixRatingRow {
    if ([self hasNetflixRating]) {
        return self.tableView.rowHeight;
    } else {
        return 0;
    }
}


- (CGFloat) heightForRowInNetflixSection:(NSInteger) row {
    if (row == 0) {
        return [self heightForNetflixRatingRow];
    } else {
        return self.tableView.rowHeight;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }

    if (indexPath.section == 1) {
        return [self heightForRowInNetflixSection:indexPath.row];
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
                                                    model:self.model] + 18;
        }
    }

    // show hidden theaters
    return tableView.rowHeight;
}


- (UITableViewCell*) cellForTheaterSection:(NSInteger) theaterIndex
                                       row:(NSInteger) row {
    if (row == 0) {
        static NSString* reuseIdentifier = @"theaterReuseIdentifier";
        TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier
                                                     model:self.model] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        [cell setTheater:theater];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"detailsReuseIdentifier";
        MovieShowtimesCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithReuseIdentifier:reuseIdentifier
                                                        model:self.model] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        BOOL stale = [self.model isStale:theater];
        [cell setStale:stale];

        [cell setShowtimes:[showtimesArray objectAtIndex:theaterIndex]];

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
      heightForFooterInSection:(NSInteger) section {
    if (section == 0) {
        CGFloat height = [actionsView height];

        return height + 1;
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
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
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

    if (indexPath.section == 1) {
        return [self cellForNetflixRow:indexPath.row];
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
    //MPMoviePlayerController* moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie.mp4" ofType:nil]]];

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

    [actionSheet showInView:[AppDelegate window]];
}


- (void) setupStatusCells {
    for (NetflixStatusCell* cell in netflixStatusCells) {
        [cell enterReadonlyMode];
    }
}


- (void) enterReadonlyMode {
    if (readonlyMode) {
        return;
    }
    readonlyMode = YES;
    [self setupTitle];
    [self setupButtons];
    [self setupStatusCells];
}


- (void) exitReadonlyMode {
    readonlyMode = NO;
    [self setupTitle];
    [self setupButtons];
}


- (void) netflixOperationSucceeded {
    [self exitReadonlyMode];
    [self majorRefresh];
}


- (void) netflixOperationFailedWithError:(NSString*) error {
    [AlertUtilities showOkAlert:error];
    [self exitReadonlyMode];
    [self majorRefresh];
}


- (void) addSucceeded {
    [self netflixOperationSucceeded];
}


- (void) addFailedWithError:(NSString*) error {
    [self netflixOperationFailedWithError:error];
}


- (void) moveSucceededForMovie:(Movie*) movie {
    [self netflixOperationSucceeded];
}


- (void) moveFailedWithError:(NSString*) error {
    [self netflixOperationFailedWithError:error];
}


- (void) modifySucceeded {
    [self netflixOperationSucceeded];
}


- (void) modifyFailedWithError:(NSString*) error {
    [self netflixOperationFailedWithError:error];
}


- (void) addToQueue {
    if (readonlyMode) {
        return;
    }

    UIActionSheet* actionSheet =
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:nil
                   destructiveButtonTitle:nil
                        otherButtonTitles:nil] autorelease];

    NSArray* formats = [self.model.netflixCache formatsForMovie:netflixMovie];

    if ([formats containsObject:@"instant"]) {
        if (formats.count == 1) {
            actionSheet.tag = ADD_TO_NETFLIX_INSTANT_QUEUE_TAG;
        } else {
            actionSheet.tag = ADD_TO_NETFLIX_DISC_OR_INSTANT_QUEUE_TAG;
        }
    } else {
        actionSheet.tag = ADD_TO_NETFLIX_DISC_QUEUE_TAG;
    }

    // we always offer the Disc queue unless the movie is instant-only.
    // (rare, but it does happen).
    if (!(formats.count == 1 && [formats containsObject:@"instant"])) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Disc Queue", nil)];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Top of Disc Queue", nil)];
    }

    if ([formats containsObject:@"instant"]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Instant Queue", nil)];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Top of Instant Queue", nil)];
    }

    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;

    [actionSheet showInView:[AppDelegate window]];
}


- (void) didDismissAddToNetflixQueue:(Queue*) queue
                     withButtonIndex:(NSInteger) buttonIndex {
    [self enterReadonlyMode];
    if (buttonIndex % 2 == 0) {
        [self.model.netflixCache updateQueue:queue byAddingMovie:netflixMovie delegate:self];
    } else {
        [self.model.netflixCache updateQueue:queue byAddingMovie:netflixMovie toPosition:0 delegate:self];
    }
}


- (void) didDismissAddToNetflixDiscQueueActionSheet:(UIActionSheet*) actionSheet
                                    withButtonIndex:(NSInteger) buttonIndex {
    Queue* queue = [self.model.netflixCache queueForKey:[NetflixCache dvdQueueKey]];
    [self didDismissAddToNetflixQueue:queue withButtonIndex:buttonIndex];
}


- (void) didDismissAddToNetflixInstantQueueActionSheet:(UIActionSheet*) actionSheet
                                       withButtonIndex:(NSInteger) buttonIndex {
    Queue* queue = [self.model.netflixCache queueForKey:[NetflixCache instantQueueKey]];
    [self didDismissAddToNetflixQueue:queue withButtonIndex:buttonIndex];

}


- (void) didDismissAddToNetflixDiscOrInstantQueueActionSheet:(UIActionSheet*) actionSheet
                                             withButtonIndex:(NSInteger) buttonIndex {
    Queue* queue;
    if (buttonIndex <= 1) {
        queue = [self.model.netflixCache queueForKey:[NetflixCache dvdQueueKey]];
    } else {
        queue = [self.model.netflixCache queueForKey:[NetflixCache instantQueueKey]];
    }
    [self didDismissAddToNetflixQueue:queue withButtonIndex:buttonIndex];
}


- (void) didDismissVisitWebsitesActionSheet:(UIActionSheet*) actionSheet
                            withButtonIndex:(NSInteger) buttonIndex {
    NSString* url = [websites objectForKey:[actionSheet buttonTitleAtIndex:buttonIndex]];
    [navigationController pushBrowser:url animated:YES];
}


- (void)            actionSheet:(UIActionSheet*) actionSheet
      didDismissWithButtonIndex:(NSInteger) buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }

    if (actionSheet.tag == ADD_TO_NETFLIX_DISC_QUEUE_TAG) {
        [self didDismissAddToNetflixDiscQueueActionSheet:actionSheet
                                         withButtonIndex:buttonIndex];
    } else if (actionSheet.tag == ADD_TO_NETFLIX_DISC_OR_INSTANT_QUEUE_TAG) {
        [self didDismissAddToNetflixDiscOrInstantQueueActionSheet:actionSheet
                                                  withButtonIndex:buttonIndex];

    } else if (actionSheet.tag == ADD_TO_NETFLIX_INSTANT_QUEUE_TAG) {
        [self didDismissAddToNetflixInstantQueueActionSheet:actionSheet
                                            withButtonIndex:buttonIndex];
    } else if (actionSheet.tag == VISIT_WEBSITES_TAG) {
        [self didDismissVisitWebsitesActionSheet:actionSheet
                                 withButtonIndex:buttonIndex];
    }
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(id) array {
    if (updateId != [[array objectAtIndex:0] intValue]) {
        return;
    }

    NSDate* searchDate = [array lastObject];

    if (![lookupResult.movies containsObject:movie]) {
        NSString* text =
        [NSString stringWithFormat:
         NSLocalizedString(@"No listings found for '%@' on %@", @"No listings found for 'The Dark Knight' on 5/18/2008"),
         movie.canonicalTitle,
         [DateUtilities formatShortDate:searchDate]];

        [self onDataProviderUpdateFailure:text context:array];
    } else {
        [super onDataProviderUpdateSuccess:lookupResult context:array];

        // Find the most up to date version of this movie
        self.movie = [lookupResult.movies objectAtIndex:[lookupResult.movies indexOfObject:movie]];
    }
}


- (void) emailListings {
    NSString* subject = [NSString stringWithFormat:@"%@ - %@",
                              movie.canonicalTitle,
                              [DateUtilities formatFullDate:self.model.searchDate]];

    NSMutableString* body = [NSMutableString string];

    for (int i = 0; i < theatersArray.count; i++) {
        [body appendString:@"<p>"];

        Theater* theater = [theatersArray objectAtIndex:i];
        NSArray* performances = [showtimesArray objectAtIndex:i];

        [body appendString:theater.name];
        [body appendString:@"<br/>"];
        [body appendString:@"<a href=\""];
        [body appendString:theater.mapUrl];
        [body appendString:@"\">"];
        [body appendString:[self.model simpleAddressForTheater:theater]];
        [body appendString:@"</a>"];

        [body appendString:@"<br/>"];
        [body appendString:[Utilities generateShowtimeLinks:self.model
                                                      movie:movie
                                                    theater:theater
                                               performances:performances]];
    }

    [self openMailWithSubject:subject body:body];
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
    if (row == 2) {
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
            [self reloadTableViewData];
        }
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self tableView:tableView didSelectHeaderRow:indexPath.row];
        return;
    }

    if (indexPath.section == 1) {
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


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) posterImageViewWasTapped {
    if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return;
    }

    if (posterCount == 0) {
        return;
    }

    [[AppDelegate operationQueue] performSelector:@selector(downloadAllPostersForMovie:)
                                         onTarget:self.model.largePosterCache
                                       withObject:movie
                                             gate:nil
                                         priority:High];

    [navigationController showPostersView:movie posterCount:posterCount];
}


- (void) moveMovieWasTappedForRow:(NSInteger) row {
    [self enterReadonlyMode];

    NetflixStatusCell* cell = [netflixStatusCells objectAtIndex:row];
    Status* status = [cell status];
    [self.model.netflixCache updateQueue:status.queue byMovingMovieToTop:status.movie delegate:self];
}


- (void) deleteMovieWasTappedForRow:(NSInteger) row {
    [self enterReadonlyMode];

    NetflixStatusCell* cell = [netflixStatusCells objectAtIndex:row];
    Status* status = [cell status];
    [self.model.netflixCache updateQueue:status.queue byDeletingMovie:status.movie delegate:self];
}


- (void) imageView:(TappableImageView*) imageView
         wasTapped:(NSInteger) tapCount {
    if (imageView.tag == POSTER_TAG) {
        [self posterImageViewWasTapped];
    } else if (imageView.tag % 2 == 0) {
        [self moveMovieWasTappedForRow:imageView.tag / 2];
    } else {
        [self deleteMovieWasTappedForRow:imageView.tag / 2];
    }
}

@end