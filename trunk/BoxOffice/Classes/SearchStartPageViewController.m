//
//  SearchStartPageViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchStartPageViewController.h"
#import "SearchNavigationController.h"
#import "XmlParser.h"
#import "XmlSerializer.h"

@implementation SearchStartPageViewController

@synthesize navigationController;
@synthesize searchBar;
@synthesize activityIndicator;

- (void) dealloc {
    self.navigationController = nil;
    self.searchBar = nil;
    [self.activityIndicator stop];
    self.activityIndicator = nil;
    [super dealloc];
}

- (void) viewWillAppear:(BOOL) animated {
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
    
//    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
  //  CGFloat height = self.navigationItem.titleView.frame.size.height;
    
    //searchBar.bounds = CGRectMake(0, 0, width, height);
    
    [self.model setCurrentlySelectedMovie:nil theater:nil];
}

- (void) removeUnusedSectionTitles {
    /*
    for (NSInteger i = [self.sectionTitles count] - 1; i >= 0; --i) {
        NSString* title = [self.sectionTitles objectAtIndex:i];
        
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }
     */
}


- (id) initWithNavigationController:(SearchNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
    
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
        searchBar.delegate = self;
        
        self.navigationItem.titleView = searchBar;
    }
    
    return self;
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
   // NSInteger section = [indexPath section];
    //NSInteger row = [indexPath row];
    /*
    Movie* movie;
    if ([self sortingByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    } else {
        movie = [self.sortedMovies objectAtIndex:row];
    }
    
    static NSString* reuseIdentifier = @"AllMoviesIdentifier";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    MovieTitleCell* movieCell = cell;
    if (movieCell == nil) {    
        movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    [movieCell setMovie:movie];    
    return movieCell;
     */
    return nil;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    /*
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    Movie* movie;
    if ([self sortingByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    } else {
        movie = [self.sortedMovies objectAtIndex:row];
    }
    
    [self.navigationController pushMovieDetails:movie animated:YES];
     */
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return 0;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return @"Movies";
    } else if (section == 1) {
        return @"People";
    } else {
        return @"Recent Searches";
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar*) bar {
    NSString* text = bar.text;
    
    [self performSelectorInBackground:@selector(search:) withObject:text];
}

- (void) search:(NSString*) text {
    NSString* urlString = [NSString stringWithFormat:@"http://localhost:8081/Search?q=%@", [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSError* httpError = nil;
    NSURLResponse* response;
    NSData* ticketData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                               returningResponse:&response
                                                           error:&httpError];
    
    if (httpError == nil && ticketData != nil) {
        XmlElement* resultElement = [XmlParser parse:ticketData];
        if (resultElement != nil) {
            NSString* result = [XmlSerializer serializeElement:resultElement];
            
            NSLog(@"%@", result);
        }
    }    
}

@end
