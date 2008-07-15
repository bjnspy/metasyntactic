//
//  SearchMovieDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchPersonDetailsViewController.h"
#import "XmlParser.h"
#import "SearchNavigationController.h"
#import "Utilities.h"
#import "Application.h"

@implementation SearchPersonDetailsViewController

#define DIRECTOR_SECTION 0
#define WRITER_SECTION 1
#define CAST_SECTION 2

@synthesize personElement;
@synthesize personDetailsElement;

- (void) dealloc {
    self.personElement = nil;
    self.personDetailsElement = nil;
    [super dealloc];
}

- (void) getPersonDetails {
    self.personDetailsElement = [[self model] getPersonDetails:[personElement attributeValue:@"id"]];
    if (self.personDetailsElement == nil) {
        [self performSelectorInBackground:@selector(lookupPersonDetails:) withObject:nil];
    }
}

- (id) initWithNavigationController:(SearchNavigationController*) navigationController_
                      personDetails:(XmlElement*) personElement_ {
    if (self = [super initWithNavigationController:navigationController_]) {
        self.personElement = personElement_;
        
        self.title = [Utilities titleForPerson:personElement];
        
        [self getPersonDetails];
    }
    
    return self;
}

- (void) lookupPersonDetails:(id) object {
    NSString* urlString =
    [NSString stringWithFormat:@"%@/LookupPerson?id=%@",
     [Application searchHost], [personElement attributeValue:@"id"]];

    XmlElement* resultElement = [Utilities downloadXml:urlString];
    
    [self performSelectorOnMainThread:@selector(reportLookupResult:) withObject:resultElement waitUntilDone:NO];
}

- (NSArray*) directedMovies {
    return [[self.personDetailsElement element:@"director"] children];
}

- (NSArray*) wroteMovies {
    return [[self.personDetailsElement element:@"writer"] children];
}

- (NSArray*) castMovies {
    return [[self.personDetailsElement element:@"cast"] children];
}

- (void) reportLookupResult:(XmlElement*) element {
    self.personDetailsElement = element;
    [[self model] setPersonDetails:[personElement attributeValue:@"id"]
                           element:element];
    
    [self.tableView reloadData];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    static NSString* reuseIdentifier = @"SearchPersonDetailsCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    XmlElement* movieElement = nil;
    if (section == DIRECTOR_SECTION) {
        movieElement = [self.directedMovies objectAtIndex:row];
    } else if (section == WRITER_SECTION) {
        movieElement = [self.wroteMovies objectAtIndex:row];
    } else if (section == CAST_SECTION) {
        movieElement = [self.castMovies objectAtIndex:row];
    }
    
    if (movieElement != nil) {
        cell.text = [Utilities titleForMovie:movieElement];
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
    
    if (section == DIRECTOR_SECTION) {
        XmlElement* movieElement = [self.directedMovies objectAtIndex:row]; 
        [self.navigationController pushMovieDetails:movieElement animated:YES];
    } else if (section == WRITER_SECTION) {
        XmlElement* movieElement = [self.wroteMovies objectAtIndex:row];
        [self.navigationController pushMovieDetails:movieElement animated:YES];
    } else if (section == CAST_SECTION) {
        XmlElement* movieElement = [self.castMovies objectAtIndex:row];
        [self.navigationController pushMovieDetails:movieElement animated:YES];
    }
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (personDetailsElement == nil) {
        return 1;
    } else {
        return 3;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if (personDetailsElement != nil) {
        if (section == DIRECTOR_SECTION) {
            return self.directedMovies.count;
        } else if (section == WRITER_SECTION) {
            return self.wroteMovies.count;
        } else if (section == CAST_SECTION) {
            return self.castMovies.count;
        }
    }
    
    return 0;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (self.personDetailsElement == nil) {
        return NSLocalizedString(@"Looking up information", nil);
    }
    
    if (section == DIRECTOR_SECTION && self.directedMovies.count > 0) {
        return NSLocalizedString(@"Director:", nil);
    } else if (section == WRITER_SECTION && self.wroteMovies.count > 0) {
        return NSLocalizedString(@"Writer:", nil);
    } else if (section == CAST_SECTION && self.castMovies.count > 0) {
        return NSLocalizedString(@"Cast member:", nil);
    }
    
    return nil;
}

@end
