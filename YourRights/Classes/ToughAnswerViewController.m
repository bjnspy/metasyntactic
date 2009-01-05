//
//  ToughAnswerViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ToughAnswerViewController.h"
#import "Model.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface ToughAnswerViewController()
@property (copy) NSString* question;
@property (copy) NSString* answer;
@end


@implementation ToughAnswerViewController

@synthesize question;
@synthesize answer;

- (void)dealloc {
    self.question = nil;
    self.answer = nil;
    [super dealloc];
}


- (id) initWithQuestion:(NSString*) question_
                     answer:(NSString*) answer_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.question = question_;
        self.answer = answer_;
    }
    
    return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:question] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:answer] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } 
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
   [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:question accessoryType:UITableViewCellAccessoryNone];
    } else {
        return [WrappableCell height:answer accessoryType:UITableViewCellAccessoryNone];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Question", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Answer", nil);
    }
    
    return nil;
}

@end