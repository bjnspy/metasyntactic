//
//  AnswerViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AnswerViewController.h"
#import "Model.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface AnswerViewController()
@property (copy) NSString* question;
@property (copy) NSString* answer;
@end


@implementation AnswerViewController

@synthesize answer;
@synthesize question;

- (void)dealloc {
    self.question = nil;
    self.answer = nil;
    [super dealloc];
}


- (id) initWithQuestion:(NSString*) question_ answer:(NSString*) answer_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.question = question_;
        self.answer = answer_;
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
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
    if (indexPath.row == 0) {
        return [WrappableCell height:question accessoryType:UITableViewCellAccessoryNone];
    } else {
        return [WrappableCell height:answer accessoryType:UITableViewCellAccessoryNone];
    }
}

@end