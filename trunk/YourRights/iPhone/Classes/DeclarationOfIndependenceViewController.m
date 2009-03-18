//
//  DeclarationOfIndependenceViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DeclarationOfIndependenceViewController.h"

#import "ConstitutionSignersViewController.h"
#import "DateUtilities.h"
#import "DeclarationOfIndependence.h"
#import "GlobalActivityIndicator.h"
#import "StringUtilities.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface DeclarationOfIndependenceViewController()
@property (retain) DeclarationOfIndependence* declaration;
@property (retain) NSArray* chunks;
@end

@implementation DeclarationOfIndependenceViewController

@synthesize declaration;
@synthesize chunks;

- (void) dealloc {
    self.declaration = nil;
    self.chunks = nil;

    [super dealloc];
}


- (id) initWithDeclaration:(DeclarationOfIndependence*) declaration_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.declaration = declaration_;
        self.title = NSLocalizedString(@"Declaration of Independence", nil);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.chunks = [StringUtilities splitIntoChunks:declaration.text];
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return chunks.count;
    } else {
        return 1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* text = [chunks objectAtIndex:indexPath.row];
        WrappableCell* cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.text = NSLocalizedString(@"Signers", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ConstitutionSignersViewController* controller = [[[ConstitutionSignersViewController alloc] initWithSigners:declaration.signers] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return [DateUtilities formatLongDate:declaration.date];
    } else {
        return NSLocalizedString(@"Information", nil);
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        NSString* text = [chunks objectAtIndex:indexPath.row];
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end
