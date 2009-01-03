//
//  NetflixSettingsViewController.m
//  MetaFlix
//
//  Created by Cyrus Najmabadi on 1/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixSettingsViewController.h"

#import "AbstractNavigationController.h"
#import "MetaFlixModel.h"

@interface NetflixSettingsViewController()
@property (assign) AbstractNavigationController* navigationController;
@end


@implementation NetflixSettingsViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
    }
    
    return self;
}


- (MetaFlixModel*) model {
    return navigationController.model;
}


- (MetaFlixController*) controller {
    return navigationController.controller;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL)animated {
    [self majorRefresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.model.netflixPreferredFormats.count;
    }
    
    return 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        cell.text = NSLocalizedString(@"Instant Watch", nil);
        UISwitch* switch_ = [[[UISwitch alloc] init] autorelease];
        switch_.enabled = NO;
        switch_.on = self.model.netflixCanInstantWatch;
        cell.accessoryView = switch_;
    } else {
        cell.text = [self.model.netflixPreferredFormats objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 1) {
        return NSLocalizedString(@"Preferred Formats", nil);
    }
    
    return nil;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == 1) {
        return NSLocalizedString(@"Currently, settings can only be modified from Netflix's website", nil);
    }
    
    return nil;
}

@end