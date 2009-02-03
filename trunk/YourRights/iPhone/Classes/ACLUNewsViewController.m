//
//  ACLUNewsController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ACLUNewsViewController.h"

#import "ACLUArticlesViewController.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "NetworkUtilities.h"
#import "RSSCache.h"
#import "YourRightsNavigationController.h"

@interface ACLUNewsViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) NSMutableArray* titlesWithArticles;
@end


@implementation ACLUNewsViewController

@synthesize navigationController;
@synthesize titlesWithArticles;

- (void) dealloc {
    self.navigationController = nil;
    self.titlesWithArticles = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"News", nil);
    }

    return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (Model*) model {
    return navigationController.model;
}


- (void) majorRefresh {
    self.titlesWithArticles = [NSMutableArray array];

    for (NSString* title in [RSSCache titles]) {
        NSArray* items = [self.model.rssCache itemsForTitle:title];
        if (items.count > 0) {
            [titlesWithArticles addObject:title];
        }
    }

    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(titlesWithArticles.count, 1);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (titlesWithArticles.count == 0) {
        return 0;
    }

    return 1;
}


- (NSString*)       tableView:(UITableView*) tableView
       titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && titlesWithArticles.count == 0) {
        if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
            return NSLocalizedString(@"Downloading data", nil);
        } else if (![NetworkUtilities isNetworkAvailable]) {
            return NSLocalizedString(@"Network unavailable", nil);
        } else {
            return NSLocalizedString(@"No information found", nil);
        }
    }

    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }

    NSString* title = [titlesWithArticles objectAtIndex:indexPath.section];
    cell.text = title;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = [[RSSCache titles] objectAtIndex:indexPath.section];
    ACLUArticlesViewController* controller = [[[ACLUArticlesViewController alloc] initWithNavigationController:navigationController title:title] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
 */


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end