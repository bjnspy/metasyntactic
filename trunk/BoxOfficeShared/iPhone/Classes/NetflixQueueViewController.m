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

#import "NetflixQueueViewController.h"

#import "CommonNavigationController.h"
#import "NetflixCell.h"

@interface NetflixQueueViewController()
@property (retain) NetflixAccount* account;
@property (copy) NSString* feedKey;
@property (retain) Feed* feed;
@property (retain) Queue* queue;
@property (retain) NSMutableArray* mutableMovies;
@property (retain) NSMutableArray* mutableSaved;
@property (retain) NSMutableSet* deletedMovies;
@property (retain) NSMutableSet* reorderedMovies;
@property (retain) UIBarButtonItem* backButton;
@end


@implementation NetflixQueueViewController

@synthesize account;
@synthesize feedKey;
@synthesize feed;
@synthesize queue;
@synthesize mutableMovies;
@synthesize mutableSaved;
@synthesize deletedMovies;
@synthesize reorderedMovies;
@synthesize backButton;

- (void) dealloc {
  self.account = nil;
  self.feedKey = nil;
  self.feed = nil;
  self.queue = nil;
  self.mutableMovies = nil;
  self.mutableSaved = nil;
  self.deletedMovies = nil;
  self.reorderedMovies = nil;
  self.backButton = nil;

  [super dealloc];
}


- (BOOL) isEditable {
  return queue.isDVDQueue || queue.isInstantQueue;
}


- (void) setupButtons {
  if (readonlyMode) {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];

    UIBarButtonItem* right = [self createActivityIndicator];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
  } else {
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIBarButtonItem* left;
    UIBarButtonItem* right;
    if (self.tableView.editing) {
      left = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)] autorelease];
      right = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)] autorelease];
    } else if (self.isEditable) {
      left = backButton;
      right = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)] autorelease];
    } else {
      left = backButton;
      right = nil;
    }

    [self.navigationItem setLeftBarButtonItem:left animated:YES];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
  }
}


- (id) initWithFeedKey:(NSString*) feedKey_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.feedKey = feedKey_;
    self.backButton = self.navigationItem.leftBarButtonItem;
    self.reorderedMovies = [NSMutableSet identitySet];
    self.deletedMovies = [NSMutableSet identitySet];
    [self setupButtons];
  }

  return self;
}


- (void) setupTitle:(NSString*) title {
  if (readonlyMode) {
    if (title.length == 0) {
      self.title = LocalizedString(@"Please Wait", nil);
    } else {
      self.title = title;
    }
  } else {
    self.title = [[NetflixCache cache] titleForKey:feedKey includeCount:NO account:account];
  }
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.account = [[NetflixAccountCache cache] currentAccount];
  self.tableView.rowHeight = 100;
  self.feed = [[NetflixFeedCache cache] feedForKey:feedKey account:account];
  self.queue = [[NetflixFeedCache cache] queueForFeed:feed account:account];
  self.mutableMovies = [NSMutableArray arrayWithArray:queue.movies];
  self.mutableSaved = [NSMutableArray arrayWithArray:queue.saved];
  [self setupTitle:@""];
  [self setupButtons];
}

/*
 - (void) majorRefresh {
 // do nothing.  we don't want to refresh the view (because it causes an
 // ugly flash).  Instead, just refresh things when teh view becomes visible
 if (mutableSaved.count == 0 && mutableMovies.count == 0) {
 return;
 }

 [super majorRefresh];
 }
 */

- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  // I don't want to clean anything else up here due to the complicated
  // state being kep around.
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 2;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  if (section == 0) {
    return mutableMovies.count;
  } else {
    return mutableSaved.count;
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (mutableMovies.count == 0 && mutableSaved.count == 0) {
    if (section == 0) {
      return [NetflixCache noInformationFound];
    }
  } else if (mutableSaved.count > 0 && section == 1) {
    return LocalizedString(@"Saved", nil);
  }

  return nil;
}


- (void) setAccessoryForCell:(NetflixCell*) cell
                 atIndexPath:(NSIndexPath*) path {
  if (self.isEditable) {
    if (path.section == 1 || path.row == 0) {
      cell.accessoryView = nil;
    } else {
      cell.accessoryView = cell.tappableArrow;
    }
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
}


- (BOOL) indexPathOutOfBounds:(NSIndexPath*) path {
  return path.row < 0 ||
  (path.section == 0 && path.row >= mutableMovies.count) ||
  (path.section == 1 && path.row >= mutableSaved.count);
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if ([self indexPathOutOfBounds:indexPath]) {
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  }

  static NSString* reuseIdentifier = @"reuseIdentifier";

  NetflixCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[NetflixCell alloc] initWithReuseIdentifier:reuseIdentifier
                                     tableViewController:self] autorelease];

    [cell.tappableArrow addTarget:self action:@selector(onUpArrowTapped:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    //cell.tappableArrow.delegate = self;
  }

  [self setAccessoryForCell:cell atIndexPath:indexPath];

  Movie* movie;
  if (indexPath.section == 0) {
    movie = [mutableMovies objectAtIndex:indexPath.row];
  } else {
    movie = [mutableSaved objectAtIndex:indexPath.row];
  }

  [cell setMovie:movie owner:self];

  return cell;
}


- (void) resetVisibleAccessories {
  for (NSIndexPath* path in self.tableView.indexPathsForVisibleRows) {
    id cell = [self.tableView cellForRowAtIndexPath:path];
    [self setAccessoryForCell:cell atIndexPath:path];
  }
}


- (void) enterReadonlyMode:(NSString*) title {
  readonlyMode = YES;
  [self setupButtons];
  [self setupTitle:title];
}


- (void) clearTemporaryQueues {
  [reorderedMovies removeAllObjects];
  [deletedMovies removeAllObjects];
}


- (void) exitReadonlyMode {
  readonlyMode = NO;
  [self setupButtons];
  [self setupTitle:@""];
  [self resetVisibleAccessories];
  [self clearTemporaryQueues];
}


- (void) upArrowTappedForRowAtIndexPath:(NSIndexPath*) indexPath {
  [self enterReadonlyMode:LocalizedString(@"Moving Movie", nil)];

  UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
  UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
  {
    [activityIndicator startAnimating];
    activityIndicator.contentMode = UIViewContentModeCenter;
    CGRect frame = activityIndicator.frame;
    frame.size.height += 80;
    frame.size.width += 20;
    activityIndicator.frame = frame;
  }
  cell.accessoryView = activityIndicator;

  Movie* movie = [mutableMovies objectAtIndex:indexPath.row];
  [[NetflixUpdater updater] updateQueue:queue byMovingMovieToTop:movie delegate:self account:account];
}


- (void) moveSucceededForMovie:(Movie*) movie {
  self.queue = [[NetflixFeedCache cache] queueForFeed:feed account:account];
  NSInteger row = [mutableMovies indexOfObjectIdenticalTo:movie];

  [self.tableView beginUpdates];
  {
    NSIndexPath* firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* currentRow = [NSIndexPath indexPathForRow:row inSection:0];

    [mutableMovies removeObjectAtIndex:row];
    [mutableMovies insertObject:movie atIndex:0];

    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentRow] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:firstRow] withRowAnimation:UITableViewRowAnimationTop];
  }
  [self.tableView endUpdates];

  [self exitReadonlyMode];
}


- (void) onModifyFailure:(NSString*) error {
  NSString* message = [NSString stringWithFormat:LocalizedString(@"Reordering queue failed:\n\n%@", @"Error shown when we tried to reorder a user's movie queue on the server but failed.  %@ is replaced with the actual error.  i.e.: Could not connect to server"), error];
  [AlertUtilities showOkAlert:message];

  [self exitReadonlyMode];

  // make sure we're in a good state.
  [self majorRefresh];
}


- (void) moveFailedWithError:(NSString*) error {
  [self onModifyFailure:error];
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (readonlyMode) {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    return;
  }

  if ([self indexPathOutOfBounds:indexPath]) {
    return;
  }

  Movie* movie;
  if (indexPath.section == 0) {
    movie = [queue.movies objectAtIndex:indexPath.row];
  } else {
    movie = [queue.saved objectAtIndex:indexPath.row];
  }

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (BOOL)          tableView:(UITableView*) tableView
      canEditRowAtIndexPath:(NSIndexPath*) indexPath {
  return self.isEditable && !readonlyMode;
}


- (BOOL)          tableView:(UITableView*) tableView
      canMoveRowAtIndexPath:(NSIndexPath*) indexPath {
  return indexPath.section == 0;
}


- (void) enterEditing {
  [self.tableView setEditing:YES animated:YES];
  majorEditing = YES;
}


- (void) exitEditing {
  [self.tableView setEditing:NO animated:YES];
  majorEditing = NO;
}


- (void) onEdit {
  [self clearTemporaryQueues];
  [self enterEditing];
  [self setupButtons];
}


- (void) onCancel {
  [self clearTemporaryQueues];
  [self exitEditing];
  [self majorRefresh];
}


- (void) onSave {
  if (deletedMovies.count == 0 && reorderedMovies.count == 0) {
    // user didn't do anything.  same as a cancel.
    [self onCancel];
  } else {
    [self exitEditing];
    NSString* title = @"";
    if (deletedMovies.count == 1 && reorderedMovies.count == 0) {
      title = LocalizedString(@"Removing Movie", nil);
    } else if (deletedMovies.count > 1 && reorderedMovies.count == 0) {
      title = LocalizedString(@"Removing Movies", nil);
    } else if (deletedMovies.count == 0 && reorderedMovies.count == 1) {
      title = LocalizedString(@"Moving Movie", nil);
    } else if (deletedMovies.count == 0 && reorderedMovies.count > 1) {
      title = LocalizedString(@"Moving Movies", nil);
    } else {
      title = LocalizedString(@"Updating Queue", nil);
    }

    [self enterReadonlyMode:title];

    [[NetflixUpdater updater] updateQueue:queue
                         byDeletingMovies:deletedMovies
                      andReorderingMovies:reorderedMovies
                                       to:mutableMovies
                                 delegate:self
                                  account:account];
  }
}


- (void)       tableView:(UITableView*) tableView
      commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
       forRowAtIndexPath:(NSIndexPath*) indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Movie* movie;
    if (indexPath.section == 0) {
      movie = [mutableMovies objectAtIndex:indexPath.row];
      [mutableMovies removeObjectAtIndex:indexPath.row];
    } else {
      movie = [mutableSaved objectAtIndex:indexPath.row];
      [mutableSaved removeObjectAtIndex:indexPath.row];
    }

    [deletedMovies addObject:movie];
    [reorderedMovies removeObject:movie];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
  }

  if (!majorEditing) {
    // This was a swipe-delete.  Commit it immediately.
    [self onSave];
  }
}


// Override to support rearranging the table view.
- (void)       tableView:(UITableView*) tableView
      moveRowAtIndexPath:(NSIndexPath*) fromIndexPath
             toIndexPath:(NSIndexPath*) toIndexPath {
  NSInteger from = fromIndexPath.row;
  NSInteger to = toIndexPath.row;

  if (from == to) {
    return;
  }

  Movie* movie = [mutableMovies objectAtIndex:from];
  [mutableMovies removeObjectAtIndex:from];
  [mutableMovies insertObject:movie atIndex:to];

  [reorderedMovies addObject:movie];
}


- (void) modifySucceeded {
  [self onBeforeReloadTableViewData];
  [self exitReadonlyMode];
}


- (void) modifyFailedWithError:(NSString*) error {
  [self onModifyFailure:error];
}


- (NSIndexPath*)                     tableView:(UITableView*) tableView
      targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*) sourceIndexPath
                           toProposedIndexPath:(NSIndexPath*) proposedDestinationIndexPath {
  if (proposedDestinationIndexPath.section == 1) {
    return [NSIndexPath indexPathForRow:(mutableMovies.count - 1) inSection:0];
  }

  return proposedDestinationIndexPath;
}


- (void) onUpArrowTapped:(UIButton*) button {
  if (readonlyMode) {
    return;
  }

  UITableViewCell* cell = nil;
  for (UIView* superview = button; superview != nil; superview = superview.superview) {
    if ([superview isKindOfClass:[UITableViewCell class]]) {
      cell = (id) superview;
      break;
    }
  }

  if (cell == nil) {
    return;
  }

  NSIndexPath* path = [self.tableView indexPathForCell:cell];
  [self upArrowTappedForRowAtIndexPath:path];
}

@end
