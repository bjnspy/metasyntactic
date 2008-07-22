//
//  AllMoviesViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AllMoviesViewController.h"
#import "MoviesNavigationController.h"
#import "Movie.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "PosterView.h"
#import "MovieTitleCell.h"
#import "DifferenceEngine.h"
#import "Application.h"
#import "DateUtilities.h"

@implementation AllMoviesViewController

@synthesize navigationController;
@synthesize sortedMovies;
@synthesize segmentedControl;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize alphabeticSectionTitles;
@synthesize posterView;

- (void) dealloc {
    self.navigationController = nil;
    self.sortedMovies = nil;
    self.segmentedControl = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.alphabeticSectionTitles = nil;
    self.posterView = nil;
    
    [super dealloc];
}

- (void) onSortOrderChanged:(id) sender {
    [[self model] setAllMoviesSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self refresh];
}

- (void) removeUnusedSectionTitles {
    for (NSInteger i = sectionTitles.count - 1; i >= 0; --i) {
        NSString* title = [sectionTitles objectAtIndex:i];
        
        if ([[sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [sectionTitles removeObjectAtIndex:i];
        }
    }    
}

- (void) sortMoviesByTitle {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByTitle context:nil];
    
    self.sectionTitles = [NSMutableArray arrayWithArray:self.alphabeticSectionTitles];
    
    for (Movie* movie in self.sortedMovies) {
        unichar firstChar = [movie.title characterAtIndex:0];
        firstChar = toupper(firstChar);
        
        if (firstChar >= 'A' && firstChar <= 'Z') {
            NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
            [self.sectionTitleToContentsMap addObject:movie forKey:sectionTitle];
        } else {
            [self.sectionTitleToContentsMap addObject:movie forKey:@"#"];
        }
    }
    
    [self removeUnusedSectionTitles];
}

- (void) sortMoviesByScore {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByScore context:self.model];
}

- (void) sortMoviesByReleaseDate {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByReleaseDate context:self.model];
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterNoStyle];
    
    NSDate* today = [DateUtilities today];
    
    for (Movie* movie in self.sortedMovies) {
        NSString* title = NSLocalizedString(@"Unknown release date", nil);
        if (movie.releaseDate != nil) {
            if ([movie.releaseDate compare:today] == NSOrderedDescending) {
                title = [Application formatFullDate:movie.releaseDate];
            } else {
                title = [DateUtilities timeSinceNow:movie.releaseDate];
            }
        }
        
        [self.sectionTitleToContentsMap addObject:movie forKey:title];
        
        if (![self.sectionTitles containsObject:title]) {
            [self.sectionTitles addObject:title];
        }
    }
    
    for (NSString* key in [self.sectionTitleToContentsMap allKeys]) {
        NSMutableArray* values = [self.sectionTitleToContentsMap mutableObjectsForKey:key];
        [values sortUsingFunction:compareMoviesByScore context:self.model];
    }
}

- (void) sortMovies { 
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];
    
    if ([self.model sortingMoviesByTitle]) {
        [self sortMoviesByTitle];
    } else if ([self.model sortingMoviesByScore]) {
        [self sortMoviesByScore];
    } else {
        [self sortMoviesByReleaseDate];
    }

    if (sectionTitles.count == 0) {
        self.sectionTitles = [NSArray arrayWithObject:[self.model noLocationInformationFound]];
    }
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
        self.sortedMovies = [NSArray array];
        
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Title", nil),
                                   NSLocalizedString(@"Score", nil), 
                                   NSLocalizedString(@"Release", nil), nil]] autorelease];
        
        
        self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        self.segmentedControl.selectedSegmentIndex = [[self model] allMoviesSelectedSegmentIndex];
        [self.segmentedControl addTarget:self
                                  action:@selector(onSortOrderChanged:)
                        forControlEvents:UIControlEventValueChanged];
        
        CGRect rect = self.segmentedControl.frame;
        rect.size.width = 240;
        self.segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
        
        self.alphabeticSectionTitles =
        [NSArray arrayWithObjects:
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", 
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", 
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        
        self.title = NSLocalizedString(@"Movies", nil);
    }
    
    return self;
}

- (void) refresh {        
    [self sortMovies];
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

    [self refresh];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
    
    [self.model setCurrentlySelectedMovie:nil theater:nil];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie;
    if ([self.model sortingMoviesByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];        
    } else if ([self.model sortingMoviesByScore]) {
        movie = [self.sortedMovies objectAtIndex:indexPath.row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    static NSString* reuseIdentifier = @"AllMoviesCellIdentifier";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    MovieTitleCell* movieCell = cell;
    if (movieCell == nil) {    
        movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                           reuseIdentifier:reuseIdentifier
                                                     model:self.model
                                                     style:UITableViewStylePlain] autorelease];
    }
    
    [movieCell setMovie:movie];    
    return movieCell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self.model sortingMoviesByTitle]) {
        return UITableViewCellAccessoryNone;
    } else if ([self.model sortingMoviesByScore]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie;
    if ([self.model sortingMoviesByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    } else if ([self.model sortingMoviesByScore]) {
        movie = [self.sortedMovies objectAtIndex:indexPath.row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushMovieDetails:movie animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if ([self.model sortingMoviesByTitle]) {
        return sectionTitles.count;
    } else if ([self.model sortingMoviesByScore]) {
        return 1;
    } else {
        return sectionTitles.count;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if ([self.model sortingMoviesByTitle]) {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
    } else if ([self.model sortingMoviesByScore]) {
        return sortedMovies.count;
    } else {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];        
    }
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if ([self.model sortingMoviesByTitle]) {
        return [self.sectionTitles objectAtIndex:section]; 
    } else if ([self.model sortingMoviesByScore] && self.sortedMovies.count > 0) {
        return nil;
    } else {
        return [self.sectionTitles objectAtIndex:section]; 
    }
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self.model sortingMoviesByTitle] && self.sortedMovies.count > 0) {
        return self.alphabeticSectionTitles;
    }
    
    return nil;
}

- (NSInteger)               tableView:(UITableView*) tableView 
          sectionForSectionIndexTitle:(NSString*) title
                              atIndex:(NSInteger) index {
    if (index == 0) {
        return index;
    }
    
    for (unichar c = [title characterAtIndex:0]; c >= 'A'; c--) {
        NSString* s = [NSString stringWithFormat:@"%c", c];
        
        NSInteger result = [self.sectionTitles indexOfObject:s];
        if (result != NSNotFound) {
            return result;
        }  
    }
    
    return 0;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {    
    return;
    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:duration];
        
        UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];

        UIWindow* window = self.navigationController.tabBarController.appDelegate.window;

        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
        
        if (orientation == UIInterfaceOrientationPortrait) {
            self.navigationController.tabBarController.view.alpha = 1;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

            if (self.posterView != nil) {
                [self.posterView removeFromSuperview];
                self.posterView = nil;
            }
        } else {
            self.navigationController.tabBarController.view.alpha = 0;
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
            
            if (self.posterView == nil) {
                self.posterView = [PosterView viewWithController:self];
            }
            
            if (self.posterView.superview == nil) {
                [window addSubview:self.posterView];
            }
        }
    }    
    [UIView commitAnimations];
}

@end
