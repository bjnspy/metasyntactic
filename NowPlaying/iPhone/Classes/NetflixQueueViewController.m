//
//  NetflixQueueViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixQueueViewController.h"

#import "AbstractNavigationController.h"
#import "ImageCache.h"
#import "MovieTitleCell.h"
#import "NetflixCache.h"
#import "NetflixMovieTitleCell.h"
#import "NowPlayingModel.h"
#import "TappableImageView.h"

@interface NetflixQueueViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) Feed* feed;
@property (retain) NSArray* movies;
@property (retain) NSArray* originalMovies;
@property (retain) UIBarButtonItem* backButton;
@end


@implementation NetflixQueueViewController

@synthesize navigationController;
@synthesize feed;
@synthesize movies;
@synthesize originalMovies;
@synthesize backButton;

- (void) dealloc {
    self.navigationController = nil;
    self.feed = nil;
    self.movies = nil;
    self.originalMovies = nil;
    self.backButton = nil;

    [super dealloc];
}


- (void) setupEditButton {
    if (self.tableView.editing) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)] autorelease];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)] autorelease];
    } else {
        self.navigationItem.leftBarButtonItem = backButton;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit:)] autorelease];
    }
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ 
                               feed:(Feed*) feed_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.feed = feed_;
        self.backButton = self.navigationItem.leftBarButtonItem;
        [self setupEditButton];
    }
    
    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) initializeData {
    self.movies = [[self.model.netflixCache queueForFeed:feed] movies];
}


- (void) majorRefresh {
    if (self.editing) {
        return;
    }

    [self initializeData];
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    [self majorRefresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (movies.count == 0) {
        return 1;
    } else {
        return movies.count;
    }
}


- (TappableImageView*) tappableArrow {
    UIImage* image = [ImageCache upArrow];
    TappableImageView* imageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
    imageView.delegate = self;
    return imageView;
}


- (void) setAccessoryForCell:(UITableViewCell*) cell
                       atRow:(NSInteger) row {
    if (row == 0) {
        cell.accessoryView = nil;
    } else {
        cell.accessoryView = [self tappableArrow];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (movies.count == 0) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.text = self.model.netflixCache.noInformationFound;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row < 0 || indexPath.row >= movies.count) {
        return [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    static NSString* reuseIdentifier = @"NetflixQueueReuseIdentifier";
    
    NetflixMovieTitleCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NetflixMovieTitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier model:self.model style:UITableViewStylePlain] autorelease];
    }
    
    [self setAccessoryForCell:cell atRow:indexPath.row];
    
    Movie* movie = [movies objectAtIndex:indexPath.row];
    [cell setMovie:movie owner:self];
    
    return cell;
}


- (void) resetVisibleAccessories {
    for (NSIndexPath* path in self.tableView.indexPathsForVisibleRows) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
        [self setAccessoryForCell:cell atRow:path.row];
    }
}


- (void) upArrowTappedForRow:(NSInteger) row {
    [self.tableView beginUpdates];
    {
        NSIndexPath* firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath* currentRow = [NSIndexPath indexPathForRow:row inSection:0];
        
        NSMutableArray* copy = [NSMutableArray arrayWithArray:movies];
        Movie* movie = [copy objectAtIndex:row];
        [copy removeObjectAtIndex:row];
        [copy insertObject:movie atIndex:0];
        self.movies = copy;
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentRow] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:firstRow] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    
    [self resetVisibleAccessories];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (upArrowTapped) {
        upArrowTapped = NO;
        [self upArrowTappedForRow:indexPath.row];
    } else {
        
    }
}



- (BOOL) tableView:(UITableView*) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (movies.count == 0) {
        return NO;
    }
    
    return YES;
}


// Override to support editing the table view.
- (void)       tableView:(UITableView*) tableView
      commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
       forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];

        NSMutableArray* copy = [NSMutableArray arrayWithArray:movies];
        [copy removeObjectAtIndex:indexPath.row];
        
        self.movies = copy;
    }   
}


// Override to support rearranging the table view.
- (void)       tableView:(UITableView*) tableView
      moveRowAtIndexPath:(NSIndexPath*) fromIndexPath
             toIndexPath:(NSIndexPath*) toIndexPath {
    NSInteger from = fromIndexPath.row;
    NSInteger to = toIndexPath.row;
    
    NSMutableArray* copy = [NSMutableArray arrayWithArray:movies];

    Movie* movie = [copy objectAtIndex:from];
    [copy removeObjectAtIndex:from];
    [copy insertObject:movie atIndex:to];
    
    self.movies = copy;
}


- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (movies.count == 0) {
        return NO;
    }
    
    return YES;
}


- (void) onEdit:(id) sender {
    [self.tableView setEditing:YES animated:YES];
    [self setupEditButton];
    self.originalMovies = movies;
}


- (void) onCancel:(id) sender {
    [self.tableView setEditing:NO animated:YES];
    [self setupEditButton];
    self.movies = originalMovies;
    
    [self.tableView reloadData];
}


- (void) onSave:(id) sender {
    [self.tableView setEditing:NO animated:YES];
    [self setupEditButton];
    [self resetVisibleAccessories];
}


- (NSIndexPath*)                     tableView:(UITableView*)tableView
      targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*) sourceIndexPath
                           toProposedIndexPath:(NSIndexPath*) proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}


- (void) imageView:(TappableImageView*) imageView
         wasTapped:(NSInteger) tapCount {
    upArrowTapped = YES;
}

@end