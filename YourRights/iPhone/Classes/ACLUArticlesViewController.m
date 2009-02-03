//
//  ACLUArticlesViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ACLUArticlesViewController.h"

#import "ArticleBodyCell.h"
#import "ArticleTitleCell.h"
#import "Item.h"
#import "Model.h"
#import "RSSCache.h"
#import "WebViewController.h"
#import "YourRightsNavigationController.h"

@interface ACLUArticlesViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (copy) NSString* title;
@property (retain) NSArray* items;
@end


@implementation ACLUArticlesViewController

@synthesize navigationController;
@synthesize title;
@synthesize items;

- (void) dealloc {
    self.navigationController = nil;
    self.title = nil;
    self.items = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                              title:(NSString*) title_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.title = title_;
    }
    
    return self;
}


- (Model*) model {
    return navigationController.model;
}


- (void) majorRefresh {
    self.items = [self.model.rssCache itemsForTitle:title];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self majorRefresh];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < items.count) {
        if (indexPath.row == 1) {
            Item* item = [items objectAtIndex:indexPath.section];
            if (item.link.length != 0) {
                return UITableViewCellAccessoryDetailDisclosureButton;
            }
        }
    }
    
    return UITableViewCellAccessoryNone;
}


- (void)                            tableView:(UITableView*) tableView
      accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < items.count) {
        Item* item = [items objectAtIndex:indexPath.section];
        if (item.link) {
            WebViewController* controller = [[[WebViewController alloc] initWithNavigationController:navigationController address:item.link showSafariButton:YES] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(items.count, 1);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (items.count == 0) {
        return 0;
    } else {
        return 2;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Item* item = [items objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        static NSString* reuseIdentifier = @"titleReuseIdentifier";
        
        ArticleTitleCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ArticleTitleCell alloc] initWithModel:self.model frame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setItem:item];
        return cell;
    } else {
        static NSString* reuseIdentifier = @"bodyReuseIdentifier";
        
        ArticleBodyCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[ArticleBodyCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setItem:item];
        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < items.count) {
        if (indexPath.row == 1) {
            Item* review = [items objectAtIndex:indexPath.section];
            
            return MAX([ArticleBodyCell height:review], self.tableView.rowHeight);
        }
    }
    
    return tableView.rowHeight;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end