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

NSInteger sortByTitle(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    return [movie1.title compare:movie2.title options:NSCaseInsensitiveSearch];
}

NSInteger sortByRating(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    BoxOfficeModel* model = context;
    
    int movieRating1 = [model rankingForMovie:movie1];
    int movieRating2 = [model rankingForMovie:movie2];
    
    if (movieRating1 < movieRating2) {
        return NSOrderedDescending;
    } else if (movieRating1 > movieRating2) {
        return NSOrderedAscending;
    }
    
    return sortByTitle(t1, t2, context);
}

NSInteger sortByReleaseDate(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    NSDate* releaseDate1 = movie1.releaseDate;
    NSDate* releaseDate2 = movie2.releaseDate;
    
    if (releaseDate1 == nil) {
        if (releaseDate2 == nil) {
            return sortByTitle(movie1, movie2, context);
        } else {
            return NSOrderedDescending;
        }
    } else if (releaseDate2 == nil) {
        return NSOrderedAscending;
    }
    
    return -[releaseDate1 compare:releaseDate2];
}

- (BOOL) sortingByTitle {
    return segmentedControl.selectedSegmentIndex == 0;
}

- (BOOL) sortingByRating {
    return segmentedControl.selectedSegmentIndex == 1;
}

- (BOOL) sortingByReleaseDate {
    return segmentedControl.selectedSegmentIndex == 2;
}

- (void) removeUnusedSectionTitles {
    for (NSInteger i = [self.sectionTitles count] - 1; i >= 0; --i) {
        NSString* title = [self.sectionTitles objectAtIndex:i];
        
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }    
}

- (void) sortMoviesByTitle {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:sortByTitle context:nil];
    
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

- (void) sortMoviesByRating {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:sortByRating context:self.model];
}

- (void) sortMoviesByReleaseDate {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:sortByReleaseDate context:self.model];
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    
    for (Movie* movie in self.sortedMovies) {
        NSString* title = NSLocalizedString(@"Unknown release date", nil);
        if (movie.releaseDate != nil) {
            NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit)
                                                       fromDate:movie.releaseDate
                                                         toDate:now
                                                        options:0];
            
            if ([components year] == 1) {
                title = NSLocalizedString(@"1 year ago", nil);
            } else if ([components year] > 1) {
                title = [NSString stringWithFormat:NSLocalizedString(@"%d years ago", nil), [components year]];
            } else if ([components month] == 1) { 
                title = NSLocalizedString(@"1 month ago", nil);
            } else if ([components month] > 1) {
                title = [NSString stringWithFormat:NSLocalizedString(@"%d months ago", nil), [components month]];
            } else if ([components week] == 1) {
                title = NSLocalizedString(@"1 week ago", nil);
            } else if ([components week] > 1) {
                title = [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago", nil), [components week]];
            } else {
                NSDateComponents* components2 = [calendar components:NSWeekdayCalendarUnit fromDate:movie.releaseDate];
                
                NSInteger weekday = [components2 weekday];
                title = [[formatter weekdaySymbols] objectAtIndex:(weekday - 1)];
            }
        }
        
        [self.sectionTitleToContentsMap addObject:movie forKey:title];
        
        if (![self.sectionTitles containsObject:title]) {
            [self.sectionTitles addObject:title];
        }
    }
    
    for (NSString* key in [self.sectionTitleToContentsMap allKeys]) {
        NSMutableArray* values = [self.sectionTitleToContentsMap mutableObjectsForKey:key];
        [values sortUsingFunction:sortByRating context:self.model];
    }
}

- (void) sortMovies { 
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];
    
    if ([self sortingByTitle]) {
        [self sortMoviesByTitle];
    } else if ([self sortingByRating]) {
        [self sortMoviesByRating];
    } else {
        [self sortMoviesByReleaseDate];
    }

    if ([self.sectionTitles count] == 0) {
        self.sectionTitles = [NSArray arrayWithObject:NSLocalizedString(@"No information found", nil)];
    }
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
        self.sortedMovies = [NSArray array];
        
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Title", nil),
                                   NSLocalizedString(@"Rating", nil), 
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
    }
    
    return self;
}

- (void) refresh {        
    [self sortMovies];
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL) animated {
    [self refresh];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
    
    [self.model setCurrentlySelectedMovie:nil theater:nil];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    Movie* movie;
    if ([self sortingByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];        
    } else if ([self sortingByRating]) {
        movie = [self.sortedMovies objectAtIndex:row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    }

    static NSString* reuseIdentifier = @"AllMoviesCellIdentifier";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    MovieTitleCell* movieCell = cell;
    if (movieCell == nil) {    
        movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier model:self.model] autorelease];
    }
    
    [movieCell setMovie:movie];    
    return movieCell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self sortingByTitle]) {
        return UITableViewCellAccessoryNone;
    } else if ([self sortingByRating]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    Movie* movie;
    if ([self sortingByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    } else if ([self sortingByRating]) {
        movie = [self.sortedMovies objectAtIndex:row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    }
    
    [self.navigationController pushMovieDetails:movie animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if ([self sortingByTitle]) {
        return [self.sectionTitles count];
    } else if ([self sortingByRating]) {
        return 1;
    } else {
        return [self.sectionTitles count];
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if ([self sortingByTitle]) {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
    } else if ([self sortingByRating]) {
        return [self.sortedMovies count];
    } else {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];        
    }
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if ([self sortingByTitle]) {
        return [self.sectionTitles objectAtIndex:section]; 
    } else if ([self sortingByRating]) {
        return nil;
    } else {
        return [self.sectionTitles objectAtIndex:section]; 
    }
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByTitle]) {
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
