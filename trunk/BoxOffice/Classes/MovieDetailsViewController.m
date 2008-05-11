//
//  MovieDetailsViewController.m
//  BoxOffice
// 
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MoviesNavigationController.h"
#import "Theater.h"
#import "DifferenceEngine.h"
#import "TicketsViewController.h"

#define SHOWTIMES_PER_ROW 6

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    [super dealloc];
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.movie = movie_;
        
        self.theatersArray = [NSMutableArray array];
        self.showtimesArray = [NSMutableArray array];
         
        for (Theater* theater in [self.model theatersShowingMovie:self.movie]) {
            [self.theatersArray addObject:theater];
            [self.showtimesArray addObject:[self.model movieShowtimes:self.movie forTheater:theater]];
        }
        
        self.title = self.movie.title;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) refresh {
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1 + [self.theatersArray count];
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 1;
    }
    
    NSInteger showtimesCount = [[self.showtimesArray objectAtIndex:(section - 1)] count];
    NSInteger rows = showtimesCount / SHOWTIMES_PER_ROW;
    NSInteger remainder = showtimesCount % SHOWTIMES_PER_ROW;
    if (remainder > 0) {
        rows++;
    }
    
    return rows;
    //return [[self.showtimesArray objectAtIndex:(section - 1)] count];
}

- (UIImage*) posterImage {
    UIImage* image = [self.model posterForMovie:self.movie];
    if (image == nil) {
        image = [UIImage imageNamed:@"ImageNotAvailable.png"];
    }
    return image;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
        
    if (section == 0 && row == 0) {
        return [self posterImage].size.height + 10;
    }
    
    return 32;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    if (section == 0 && row == 0) {
        UIImage* image = [self posterImage];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(5, 5, image.size.width, image.size.height);
        [cell.contentView addSubview:imageView];
        
        int webX = 5 + image.size.width + 5;
        int webWidth = 295 - webX;
        CGRect webRect = CGRectMake(webX, 5, webWidth, image.size.height);
        UIWebView* webView = [[[UIWebView alloc] initWithFrame:webRect] autorelease];
        
        NSString* content =
            [NSString stringWithFormat:
                @"<html>"
                    "<head>"
                        "<style>"
                            "body {"
                                "  margin-top: -2;"
                                "  margin-bottom: 0;"
                                "  margin-right: 3;"
                                "  margin-left: 3;"
                                "  font-family: \"helvetica\";"
                                "  font-size: 14;"
                            "}"
                        "</style>"
                    "</head>"
                    "<body>%@</body>"
                "</html>", movie.synopsis];
        [webView loadHTMLString:content baseURL:[NSURL URLWithString:@""]];
        [cell.contentView addSubview:webView]; 
    } else {
        NSInteger startIndex = row * SHOWTIMES_PER_ROW;
        NSArray* showtimes = [self.showtimesArray objectAtIndex:(section - 1)];
        NSString* result = [showtimes objectAtIndex:startIndex];
        for (NSInteger i = startIndex + 1;
             i < [showtimes count] && i < (startIndex + SHOWTIMES_PER_ROW);
             i++) {
            result = [result stringByAppendingString:@", "];
            result = [result stringByAppendingString:[showtimes objectAtIndex:i]];
        }
        
        
        cell.font = [UIFont boldSystemFontOfSize:11];
        cell.text = result;
        //cell.text = [[self.showtimesArray objectAtIndex:(section - 1)] objectAtIndex:row];
    }
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    }
    
    return [[self.theatersArray objectAtIndex:(section - 1)] name];
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    
    Theater* theater = [self.theatersArray objectAtIndex:(section - 1)];    
    [self.navigationController pushViewController:[[[TicketsViewController alloc] initWithController:self.navigationController
                                                                                            theater:theater
                                                                                            movie:self.movie] autorelease]
                                         animated:YES];
}

@end
