//
//  MovieDetailsViewController.m
//  BoxOffice
// 
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MoviesNavigationController.h"

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                              movie:(Movie*) movie_
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.navigationController = controller;
        self.movie = movie_;
                
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
    return 1;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section
{
    return 1;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    UIImage* image = [self.model posterForMovie:self.movie];
    if (image == nil)
    {
        cell.text = @"No image";
    }
    else
    {
        [cell.contentView addSubview:[[[UIImageView alloc] initWithImage:image] autorelease]];
    }
    
    return cell;
}

@end
