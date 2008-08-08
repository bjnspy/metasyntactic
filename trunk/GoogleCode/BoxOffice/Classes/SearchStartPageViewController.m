// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchStartPageViewController.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "SearchNavigationController.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Utilities.h"
#import "XmlElement.h"

#define MOVIES_SECTION 0
#define PEOPLE_SECTION 1
#define RECENTLY_VIEWED_SECTION 2

@implementation SearchStartPageViewController

@synthesize navigationController;
@synthesize searchBar;
@synthesize activityIndicator;
@synthesize activityView;
@synthesize searchResult;
@synthesize recentResults;

- (void) dealloc {
    self.navigationController = nil;
    self.searchBar = nil;
    self.activityIndicator = nil;
    self.activityView = nil;

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

        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(20, 0, 270, 44)] autorelease];
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.searchBar.delegate = self;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        searchId = 0;
        searchCount = 0;

        self.navigationItem.titleView = searchBar;

        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = self.activityIndicator.frame;
        frame.size.width += 10;

        self.activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [activityView addSubview:self.activityIndicator];
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    static NSString* reuseIdentifier = @"SearchStartPageCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }

    XmlElement* movieElement = nil;
    XmlElement* personElement = nil;
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        XmlElement* result = [XmlElement elementFromDictionary:[[self.model getSearchResults] objectForKey:[recentResults objectAtIndex:row]]];
        movieElement = [result element:@"movie"];
        personElement = [result element:@"person"];
    } else if (section == MOVIES_SECTION) {
        movieElement = [self.movies objectAtIndex:row];
    } else if (section == PEOPLE_SECTION) {
        personElement = [self.people objectAtIndex:row];
    }

    NSString* text;
    if (movieElement != nil) {
        text = [Utilities titleForMovie:movieElement];
    } else if (personElement != nil) {
        text = [personElement attributeValue:@"name"];
    }

    //[text siz

    cell.text = text;
    return cell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    XmlElement* movieElement = nil;
    XmlElement* personElement = nil;
    if (searchResult == nil || section == RECENTLY_VIEWED_SECTION) {
        XmlElement* result = [XmlElement elementFromDictionary:[[self.model getSearchResults] objectForKey:[recentResults objectAtIndex:row]]];
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
    self.recentResults = [[self.model getSearchResults] allKeys];
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

    {
        ++searchId;
        SearchRequest* request = [SearchRequest requestWithText:bar.text searchId:searchId];

        [self performSelectorInBackground:@selector(search:) withObject:request];
    }

    {
        ++searchCount;
        if (searchCount == 1) {
            [UIView beginAnimations:nil context:nil];
            {
                [self.activityIndicator startAnimating];

                UIBarButtonItem* item =  [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];
                [self.navigationItem setRightBarButtonItem:item animated:YES];
            }
            [UIView commitAnimations];
        }
    }
}

- (void) searchWorker:(SearchRequest*) request {
    NSString* urlString =
    [NSString stringWithFormat:@"%@/Search?q=%@",
     [Application searchHost],
     [request.text stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding]];

    XmlElement* element = [Utilities downloadXml:urlString];

    SearchResult* result = [SearchResult resultWithElement:element searchId:request.searchId];
    [self performSelectorOnMainThread:@selector(reportSearchResult:) withObject:result waitUntilDone:NO];
}

- (void) search:(SearchRequest*) request {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    {
        [self searchWorker:request];
    }
    [autoreleasePool release];
}

- (void) reportSearchResult:(SearchResult*) result {
    if (result.searchId == searchId) {
        self.searchResult = result.element;
        [self.tableView reloadData];
    }

    {
        --searchCount;
        if (searchCount == 0) {
            [UIView beginAnimations:nil context:nil];
            {
                [self.activityIndicator stopAnimating];
                [self.navigationItem setRightBarButtonItem:nil animated:YES];
            }
            [UIView commitAnimations];
        }
    }
}

@end
