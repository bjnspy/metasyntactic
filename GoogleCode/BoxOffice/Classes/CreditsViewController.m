//
//  CreditsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 6/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CreditsViewController.h"
#import "Application.h"

@implementation CreditsViewController

@synthesize fandangoImage;
@synthesize ignyteImage;
@synthesize rottenTomatoesImage;
@synthesize tryntImage;
@synthesize yahooImage;

- (void) dealloc {
    self.fandangoImage = nil;
    self.ignyteImage = nil;
    self.rottenTomatoesImage = nil;
    self.tryntImage = nil;
    self.yahooImage = nil;
    [super dealloc];
}

- (id) init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.fandangoImage = [UIImage imageNamed:@"FandangoLogo.png"];
        self.ignyteImage = [UIImage imageNamed:@"IgnyteLogo.png"];
        self.rottenTomatoesImage = [UIImage imageNamed:@"RottenTomatoesLogo.png"];
        self.tryntImage = [UIImage imageNamed:@"TryntLogo.png"];
        self.yahooImage = [UIImage imageNamed:@"YahooLogo.png"];
        
        self.title = NSLocalizedString(@"About", nil);
    }
    
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 6;
}

- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    }
    
    if (section == 5) {
        return 2;
    }
    
    return 1;
}

- (UIImage*) getImage:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 1) {
        return rottenTomatoesImage;
    } else if (section == 2) {
        return ignyteImage;
    } else if (section == 3) {
        return fandangoImage;
    } else if (section == 4) {
        return tryntImage;
    } else if (section == 5) {
        if (row == 0) {
            return yahooImage;
        }
    }
    
    return nil;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    
    UIImage* image = [self getImage:indexPath];
    CGFloat height = [tableView rowHeight];;
    if (image != nil) {
        CGFloat imageHeight = image.size.height + 10;
        if (imageHeight > height) {
            height = imageHeight;
        }
    }
    
    return height;
}

- (UITableViewCell*)    tableView:(UITableView*) tableView
            cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage* image = [self getImage:indexPath];
    
    if (image != nil) {
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        
        NSInteger yMid = (NSInteger)([self tableView:tableView heightForRowAtIndexPath:indexPath] / 2);
        NSInteger xMid = 130;
        
        NSInteger x = xMid - (image.size.width / 2);
        NSInteger y = yMid - (image.size.height / 2);
        imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);

        [cell.contentView addSubview:imageView];
    } else if (section == 0) {
        if (row == 0) {
            cell.text = @"Cyrus Najmabadi";
        } else {
            cell.text = NSLocalizedString(@"Project website", nil);
        }
    } else {
        cell.text = @"GeoNames";
        cell.textColor = [UIColor colorWithRed:33.0/256.0 green:66.0/256.0 blue:33.0/256.0 alpha:1.0];
    }
    
    return cell;
}

- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Written by:", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Movie ratings provided by:", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"Theater listings provided by:", nil);
    } else if (section == 3) {
        return NSLocalizedString(@"Ticket sales provided by:", nil);
    } else if (section == 4) {
        return NSLocalizedString(@"Movie details provided by:", nil);
    } else if (section == 5) {
        return NSLocalizedString(@"Geolocation services provided by:", nil);
    }
    
    return nil;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString* url = nil;
    if (section == 0) {
        if (row == 0) {
            url = @"mailto:cyrus.najmabadi@gmail.com";
        } else {
            url = @"http://metasyntactic.googlecode.com";
        }
    } else if (section == 1) {
        url = @"http://www.rottentomatoes.com";
    } else if (section == 2) {
        url = @"http://www.ignyte.com";
    } else if (section == 3) {
        url = @"http://www.fandango.com";
    } else if (section == 4) {
        url = @"http://www.trynt.com";
    } else if (section == 5) {
        if (row == 0) {
            url = @"http://www.yahoo.com";
        } else {
            url = @"http://www.geonames.org";
        }
    }
    
    [Application openBrowser:url];
}


@end
