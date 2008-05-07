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
    if (self = [super init])
    {
        self.navigationController = controller;
        self.movie = movie_;
         
        
        {
            CGRect screenRect = self.view.bounds;
            CGFloat padding = 15;
            
            UIImage* image = [self.model posterForMovie:self.movie];
            if (image == nil)
            {
                image = [UIImage imageNamed:@"ImageNotAvailable.png"];
            }
            
            UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            CGFloat headerHeight = image.size.height;
            
            CGRect imageBounds = { 
                { padding, padding },
                { image.size.width, headerHeight }
            };
            
            imageView.frame = imageBounds;
            
            CGFloat synopsisStartX = padding + imageBounds.size.width + padding;
            CGRect synopsisBounds = { 
                { synopsisStartX, padding },
                { (screenRect.size.width - padding) - synopsisStartX, headerHeight }
            };
            
            UIWebView* synopsisView = [[[UIWebView alloc] initWithFrame:synopsisBounds] autorelease];
            [synopsisView loadHTMLString:self.movie.synopsis baseURL:[NSURL URLWithString:@""]];
            
            [self.view addSubview:imageView];
            [self.view addSubview:synopsisView];
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
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        CGRect bounds = { { 20, 20 }, { 100, 140 } };
        imageView.bounds = bounds;
        [self.view addSubview:imageView];
    }
    
    return cell;
}

@end
