//
//  SearchMovieDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchMovieDetailsViewController.h"
#import "XmlParser.h"
#import "SearchNavigationController.h"
#import "Utilities.h"

@implementation SearchMovieDetailsViewController

#define DIRECTORS_SECTION 0
#define WRITERS_SECTION 1
#define CAST_SECTION 2

@synthesize movieElement;
@synthesize movieDetailsElement;

- (void) dealloc {
    self.movieElement = nil;
    self.movieDetailsElement = nil;
    [super dealloc];
}

- (void) getMovieDetails {
    self.movieDetailsElement = [[self model] getMovieDetails:[movieElement attributeValue:@"id"]];
    if (self.movieDetailsElement == nil) {
        [self performSelectorInBackground:@selector(lookupMovieDetails:) withObject:nil];
    }
}

- (id) initWithNavigationController:(SearchNavigationController*) navigationController_
                       movieDetails:(XmlElement*) movieElement_ {
    if (self = [super initWithNavigationController:navigationController_]) {
        self.movieElement = movieElement_;
        
        self.title = [Utilities titleForMovie:movieElement];
        
        [self getMovieDetails];
    }
    
    return self;
}

- (void) lookupMovieDetails:(id) object {
    NSString* urlString = [NSString stringWithFormat:@"http://metaboxoffice2.appspot.com/LookupMovie?id=%@", [movieElement attributeValue:@"id"]];

    XmlElement* resultElement = [Utilities downloadXml:urlString];
    
    [self performSelectorOnMainThread:@selector(reportLookupResult:) withObject:resultElement waitUntilDone:NO];
}

- (NSArray*) directors {
    return [[self.movieDetailsElement element:@"directors"] children];
}

- (NSArray*) writers {
    return [[self.movieDetailsElement element:@"writers"] children];
}

- (NSArray*) cast {
    return [[self.movieDetailsElement element:@"cast"] children];
}

- (void) reportLookupResult:(XmlElement*) element {
    self.movieDetailsElement = element;
    [[self model] setMovieDetails:[movieElement attributeValue:@"id"]
                           element:element];
    
    [self.tableView reloadData];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    static NSString* reuseIdentifier = @"SearchMovieDetailsCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    XmlElement* personElement = nil;
    if (section == DIRECTORS_SECTION) {
        personElement = [self.directors objectAtIndex:row];
    } else if (section == WRITERS_SECTION) {
        personElement = [self.writers objectAtIndex:row];
    } else if (section == CAST_SECTION) {
        personElement = [self.cast objectAtIndex:row];
    }

    if (personElement != nil) {
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
    
    if (section == DIRECTORS_SECTION) {
        XmlElement* personElement = [self.directors objectAtIndex:row]; 
        [self.navigationController pushPersonDetails:personElement animated:YES];
    } else if (section == WRITERS_SECTION) {
        XmlElement* personElement = [self.writers objectAtIndex:row];
        [self.navigationController pushPersonDetails:personElement animated:YES];
    } else if (section == CAST_SECTION) {
        XmlElement* personElement = [self.cast objectAtIndex:row];
        [self.navigationController pushPersonDetails:personElement animated:YES];
    }
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (movieDetailsElement == nil) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if (movieDetailsElement != nil) {
        if (section == DIRECTORS_SECTION) {
            return [self.directors count];
        } else if (section == WRITERS_SECTION) {
            return [self.writers count];
        } else if (section == CAST_SECTION) {
            return [self.cast count];
        }
    }
    
    return 0;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (self.movieDetailsElement == nil) {
        return NSLocalizedString(@"Looking up information", nil);
    }
    
    if (section == DIRECTORS_SECTION && [self.directors count] > 0) {
        return NSLocalizedString(@"Directed by:", nil);
    } else if (section == WRITERS_SECTION && [self.writers count] > 0) {
        return NSLocalizedString(@"Written by:", nil);
    } else if (section == CAST_SECTION && [self.cast count] > 0) {
        return NSLocalizedString(@"Cast:", nil);
    }
    
    return nil;
}

@end
