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

#import "SearchMovieDetailsViewController.h"
#import "Application.h"
#import "AutoresizingCell.h"
#import "BoxOfficeModel.h"
#import "SearchNavigationController.h"
#import "Utilities.h"
#import "XmlParser.h"

@implementation SearchMovieDetailsViewController

#define TAGLINES_SECTION 0
#define DIRECTORS_SECTION 1
#define WRITERS_SECTION 2
#define CAST_SECTION 3

@synthesize movieElement;
@synthesize movieDetailsElement;

- (void) dealloc {
    self.movieElement = nil;
    self.movieDetailsElement = nil;
    [super dealloc];
}

- (void) getMovieDetails {
    self.movieDetailsElement = [self.model getMovieDetails:[movieElement attributeValue:@"id"]];
    if (self.movieDetailsElement == nil) {
        [self startActivityIndicator];
        [self performSelectorInBackground:@selector(lookupMovieDetails:) withObject:movieElement];
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

- (void) lookupMovieDetails:(id) element {
    NSString* urlString =
    [NSString stringWithFormat:@"%@/LookupMovie?id=%@",
     [Application searchHost], [element attributeValue:@"id"]];

    XmlElement* resultElement = [Utilities downloadXml:urlString];

    [self performSelectorOnMainThread:@selector(reportLookupResult:) withObject:resultElement waitUntilDone:NO];
}

- (NSArray*) taglines {
    return [[self.movieDetailsElement element:@"taglines"] children];
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
    [self stopActivityIndicator];
    self.movieDetailsElement = element;
    [self.model setMovieDetails:[movieElement attributeValue:@"id"]
                           element:element];

    [self.tableView reloadData];
}

- (CGSize) getStringSize:(NSString*) text {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:14]
                   constrainedToSize:CGSizeMake(width - 10, 5000)
                       lineBreakMode:UILineBreakModeCharacterWrap];

    return size;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == TAGLINES_SECTION) {
        NSString* text = [self.taglines objectAtIndex:row];

        CGSize size = [self getStringSize:text];
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 4, size.width, size.height)] autorelease];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.backgroundColor = [UIColor clearColor];
        label.opaque = NO;
        label.numberOfLines = 0;
        label.text = text;

        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        [cell.contentView addSubview:label];

        return cell;
    } else {
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
            cell.text = [personElement attributeValue:@"name"];
        }

        return cell;
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;

    if (section == TAGLINES_SECTION) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

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
        return 4;
    }
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if (movieDetailsElement != nil) {
        if (section == TAGLINES_SECTION) {
            return [self.taglines count];
        } else if (section == DIRECTORS_SECTION) {
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

    if (section == TAGLINES_SECTION && [self.taglines count] > 0) {
        return NSLocalizedString(@"Taglines:", nil);
    } else if (section == DIRECTORS_SECTION && [self.directors count] > 0) {
        return NSLocalizedString(@"Directed by:", nil);
    } else if (section == WRITERS_SECTION && [self.writers count] > 0) {
        return NSLocalizedString(@"Written by:", nil);
    } else if (section == CAST_SECTION && [self.cast count] > 0) {
        return NSLocalizedString(@"Cast:", nil);
    }

    return nil;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        NSString* text = [self.taglines objectAtIndex:row];
        CGSize size = [self getStringSize:text];

        return size.height + 9;
    } else {
        return [tableView rowHeight];
    }
}

@end
