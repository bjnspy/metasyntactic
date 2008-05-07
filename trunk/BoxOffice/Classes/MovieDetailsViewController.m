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

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                              movie:(Movie*) movie_
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.navigationController = controller;
        self.movie = movie_;
        
        self.theatersArray = [NSMutableArray array];
        self.showtimesArray = [NSMutableArray array];
         
        for (Theater* theater in [[self model] theaters])
        {
            for (NSString* movieName in theater.movieToShowtimesMap)
            {
                if ([DifferenceEngine areSimilar:self.movie.title other:movieName])
                {
                    [self.theatersArray addObject:theater];
                    [self.showtimesArray addObject:[theater.movieToShowtimesMap valueForKey:movieName]];
                    break;
                }
            }
        }
        
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.title = self.movie.title;
    }
    
    return self;
}

- (void) dealloc
{
    self.navigationController = nil;
    self.movie = nil;
    [super dealloc];
}

- (void) refresh
{
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView
{
    return 1 + [self.theatersArray count];
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section
{
    if (section == 0)
    {
        return 1;
    }
    
    return [[self.showtimesArray objectAtIndex:(section - 1)] count];
}

- (UIImage*) posterImage
{
    UIImage* image = [self.model posterForMovie:self.movie];
    if (image == nil)
    {
        image = [UIImage imageNamed:@"ImageNotAvailable.png"];
    }
    return image;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
        
    if (section == 0 && row == 0)
    {
        return [self posterImage].size.height + 10;
    }
    
    return 42;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    if (section == 0 && row == 0)
    {
        UIImage* image = [self posterImage];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(5, 5, image.size.width, image.size.height);
        [cell.contentView addSubview:imageView];
        
        CGRect webRect = CGRectMake(5 + image.size.width + 5, 5, 190, image.size.height);
        UIWebView* webView = [[[UIWebView alloc] initWithFrame:webRect] autorelease];
        [webView loadHTMLString:movie.synopsis baseURL:[NSURL URLWithString:@""]];
        [cell.contentView addSubview:webView];
    }
    else
    {
        cell.text = [[self.showtimesArray objectAtIndex:(section - 1)] objectAtIndex:row];
    }
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section
{
    if (section == 0)
    {
        return nil;
    }
    
    return [[self.theatersArray objectAtIndex:(section - 1)] name];
}

@end
