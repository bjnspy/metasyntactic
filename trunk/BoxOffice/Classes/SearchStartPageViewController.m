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
#import "Utilities.h"

#define MOVIES_SECTION 0
#define PEOPLE_SECTION 1
#define RECENTLY_VIEWED_SECTION 2

@implementation SearchStartPageViewController

@synthesize navigationController;
@synthesize searchBar;
@synthesize activityIndicator;
@synthesize searchResult;
@synthesize recentResults;

- (void) dealloc {
    self.navigationController = nil;
    self.searchBar = nil;
    
    [self.activityIndicator stop];
    self.activityIndicator = nil;
    
    self.searchResult = nil;
    self.recentResults = nil;
    
    [super dealloc];
}

- (void) viewWillAppear:(BOOL) animated {
    [self.model setCurrentlySelectedMovie:nil theater:nil];
    [self refresh];
}

- (id) initWithNavigationController:(SearchNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
    
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.searchBar.delegate = self;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        searchId = 0;
        
        self.navigationItem.titleView = searchBar;
    }
    
    return self;
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (XmlElement*) moviesElement { 
    return [searchResult element:@"movies"];
}

- (XmlElement*) peopleElement { 
    return [searchResult element:@"people"];
}

- (NSArray*) movies {
    return [self.moviesElement children];
}

- (NSArray*) people { 
    return [self.peopleElement children];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    static NSString* reuseIdentifier = @"SearchStartPageCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    XmlElement* movieElement = nil;
    XmlElement* personElement = nil;
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        XmlElement* result = [XmlElement elementFromDictionary:[[[self model] getSearchResults] objectForKey:[recentResults objectAtIndex:row]]];
        movieElement = [result element:@"movie"];
        personElement = [result element:@"person"];
    } else if (section == MOVIES_SECTION) {
        movieElement = [self.movies objectAtIndex:row];
    } else if (section == PEOPLE_SECTION) {
        personElement = [self.people objectAtIndex:row];
    }
    
    if (movieElement != nil) {
        cell.text = [Utilities titleForMovie:movieElement];
    } else if (personElement != nil) {
        cell.text = [Utilities titleForPerson:personElement];
    }
    
    return cell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];

    XmlElement* movieElement = nil;
    XmlElement* personElement = nil;
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        XmlElement* result = [XmlElement elementFromDictionary:[[[self model] getSearchResults] objectForKey:[recentResults objectAtIndex:row]]];
        movieElement = [result element:@"movie"];
        personElement = [result element:@"person"];        
    } else if (section == MOVIES_SECTION) {
        movieElement = [self.movies objectAtIndex:row];
    } else if (section == PEOPLE_SECTION) {
        personElement = [self.people objectAtIndex:row];
    }    
    
    if (movieElement != nil) {
        [self.navigationController pushMovieDetails:movieElement animated:YES];
    } else if (personElement != nil) {
        [self.navigationController pushPersonDetails:personElement animated:YES];
    }
}

- (void) refresh {
    self.recentResults = [[[self model] getSearchResults] allKeys];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (searchResult == nil) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        return [self.recentResults count];
    } else if (section == MOVIES_SECTION) {
        return [self.movies count];
    } else if (section == PEOPLE_SECTION) {
        return [self.people count];
    }
    
    return 0;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        return NSLocalizedString(@"Recently viewed:", nil);
    } else if (section == MOVIES_SECTION && [self.movies count] > 0) {
        return NSLocalizedString(@"Movies:", nil);
    } else if (section == PEOPLE_SECTION && [self.people count] > 0) {
        return NSLocalizedString(@"People:", nil);
    }
    
    return nil;
}

- (void) searchBarSearchButtonClicked:(UISearchBar*) bar {
    [bar resignFirstResponder];
    
    NSString* text = bar.text;
    searchId++;
    [self performSelectorInBackground:@selector(search:) withObject:text];
}

- (void) search:(NSString*) text {
    NSInteger id = searchId;
    NSString* urlString = [NSString stringWithFormat:@"http://metaboxoffice2.appspot.com/Search?q=%@", [text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSError* httpError = nil;
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                               returningResponse:&response
                                                           error:&httpError];
    
    XmlElement* resultElement = nil;
    if (httpError == nil && data != nil) {
        resultElement = [XmlParser parse:data];
    }
    
    if (id == searchId) {
        [self performSelectorOnMainThread:@selector(reportSearchResult:) withObject:resultElement waitUntilDone:NO];
    }
}

- (void) reportSearchResult:(XmlElement*) element {
    self.searchResult = element;
    [self.tableView reloadData];
}

@end
