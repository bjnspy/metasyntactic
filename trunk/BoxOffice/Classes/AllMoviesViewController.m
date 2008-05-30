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

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
    
    [self.model setCurrentlySelectedMovie:nil theater:nil];
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
    
    int movieRating1 = [movie1 ratingValue];
    int movieRating2 = [movie2 ratingValue];
    
    if (movieRating1 < movieRating2) {
        return NSOrderedDescending;
    } else if (movieRating1 > movieRating2) {
        return NSOrderedAscending;
    }
    
    return sortByTitle(t1, t2, context);
}

- (BOOL) sortingByTitle {
    return segmentedControl.selectedSegmentIndex == 0;
}

- (BOOL) sortingByRating {
    return ![self sortingByTitle];
}

- (void) removeUnusedSectionTitles {
    for (NSInteger i = [self.sectionTitles count] - 1; i >= 0; --i) {
        NSString* title = [self.sectionTitles objectAtIndex:i];
        
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }    
}

- (BOOL)            set:(NSSet*) set
        containsSimilar:(NSString*) value {
    for (NSString* string in set) {
        if ([[Application differenceEngine] similar:string other:value]) {
            return YES;
        }
    }    
    
    return NO;
}

- (NSArray*) filterMovies:(NSArray*) movies {
    NSMutableSet* set = [NSMutableSet set];
    
    for (Theater* theater in self.model.theaters) {
        [set addObjectsFromArray:[theater.movieToShowtimesMap allKeys]];
    }
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (Movie* movie in movies) {
        if ([self set:set containsSimilar:movie.title]) {
            [result addObject:movie];
        }
    }
    
    return result;
}

- (void) sortMoviesByTitle {
    NSArray* movies = [self filterMovies:self.model.movies];
    self.sortedMovies = [movies sortedArrayUsingFunction:sortByTitle context:nil];
    
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
    NSArray* movies = [self filterMovies:self.model.movies];
    self.sortedMovies = [movies sortedArrayUsingFunction:sortByRating context:nil];
}

- (void) sortMovies { 
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];
    
    if ([self sortingByTitle]) {
        [self sortMoviesByTitle];
    } else {
        [self sortMoviesByRating];
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
                                  [NSArray arrayWithObjects:NSLocalizedString(@"Title", nil), NSLocalizedString(@"Rating", nil), nil]] autorelease];
        
        
        self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        self.segmentedControl.selectedSegmentIndex = [[self model] allMoviesSelectedSegmentIndex];
        [self.segmentedControl addTarget:self
         action:@selector(onSortOrderChanged:)
         forControlEvents:UIControlEventValueChanged];
        
        CGRect rect = self.segmentedControl.frame;
        rect.size.width = 200;
        self.segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
        
        self.alphabeticSectionTitles =
        [NSArray arrayWithObjects:
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", 
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", 
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        
        [self sortMovies];
    }
    
    return self;
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
    } else {
        movie = [self.sortedMovies objectAtIndex:row];
    }

    static NSString* reuseIdentifier = @"AllMoviesCellIdentifier";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    MovieTitleCell* movieCell = cell;
    if (movieCell == nil) {    
        movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    [movieCell setMovie:movie];    
    return movieCell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self sortingByTitle]) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    Movie* movie;
    if ([self sortingByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    } else {
        movie = [self.sortedMovies objectAtIndex:row];
    }
    
    [self.navigationController pushMovieDetails:movie animated:YES];
}

- (void) refresh {
    [self sortMovies];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if ([self sortingByTitle]) {
        return [self.sectionTitles count];
    } else {
        return 1;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if ([self sortingByTitle]) {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
    } else {
        return [self.sortedMovies count];
    }
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if ([self sortingByTitle]) {
        return [self.sectionTitles objectAtIndex:section]; 
    }
    
    return nil;
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
    //return NO;
    return YES;
    //return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    //return;
//    NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
    
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
