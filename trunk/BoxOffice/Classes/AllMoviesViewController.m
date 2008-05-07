//
//  AllMoviesViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllMoviesViewController.h"
#import "MoviesNavigationController.h"
#import "Movie.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "MovieTitleAndRatingTableViewCell.h"

@implementation AllMoviesViewController

@synthesize navigationController;
@synthesize sortedMovies;
@synthesize segmentedControl;

- (void) dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.navigationController = nil;
    self.sortedMovies = nil;
    self.segmentedControl = nil;
    [super dealloc];
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.title = @"All Movies";
        self.navigationController = controller;
        self.sortedMovies = [NSArray array];
                
        segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                             [NSArray arrayWithObjects:@"Title", @"Rating", nil]] autorelease];
    
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        segmentedControl.selectedSegmentIndex = 1;
        [segmentedControl addTarget:self
                             action:@selector(onSortOrderChanged:)
                   forControlEvents:UIControlEventValueChanged];
        CGRect rect = segmentedControl.frame;
        rect.size.width = 200;
        segmentedControl.frame = rect;
        
        self.navigationItem.customTitleView = segmentedControl;
        
        //self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void) onSortOrderChanged:(id) sender
{
    [self refresh];
}

NSInteger sortByTitle(id t1, id t2, void *context)
{
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    return [movie1.title compare:movie2.title options:NSCaseInsensitiveSearch];
}


NSInteger sortByRating(id t1, id t2, void *context)
{
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    int compare = [movie1 ratingValue] - [movie2 ratingValue];
    if (compare < 0)
    {
        return NSOrderedDescending;
    }
    else if (compare > 0)
    {
        return NSOrderedAscending;
    }
    
    return sortByTitle(t1, t2, context);
}

- (void) sortMovies
{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:(index == 0 ? sortByTitle : sortByRating)
                                                            context:nil];
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section
{
    return [self.sortedMovies count];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    Movie* movie = [self.sortedMovies objectAtIndex:[indexPath indexAtPosition:1]];
    MovieTitleAndRatingTableViewCell* cell = [[[MovieTitleAndRatingTableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                                                                                movie:movie] autorelease];
    return cell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)                     tableView:(UITableView*) tableView
         selectionDidChangeToIndexPath:(NSIndexPath*) newIndexPath
                         fromIndexPath:(NSIndexPath*) oldIndexPath
{
    [self.navigationController pushMovieDetails:[self.sortedMovies objectAtIndex:[newIndexPath indexAtPosition:1]]];
}

- (void) refresh
{
    [self sortMovies];
    [self.tableView reloadData];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (void) onDeviceOrientationDidChange:(id) argument
{
    
    NSLog(@"device orientation changed");
}

@end
