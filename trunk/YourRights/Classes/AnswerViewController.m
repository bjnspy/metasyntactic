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
@property (copy) NSString* sectionTitle;
@property (copy) NSString* question;
@property (copy) NSString* answer;
@property (retain) NSArray* links;
@end


@implementation AnswerViewController

@synthesize sectionTitle;
@synthesize question;
@synthesize answer;
@synthesize links;

- (void)dealloc {
    self.sectionTitle = nil;
    self.question = nil;
    self.answer = nil;
    self.links = nil;
    [super dealloc];
}


- (id) initWithSectionTitle:(NSString*) sectionTitle_
                   question:(NSString*) question_
                     answer:(NSString*) answer_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.sectionTitle = sectionTitle_;
        self.question = question_;
        self.answer = answer_;
        self.links = [Model linksForQuestion:question withSectionTitle:sectionTitle];
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return links.count;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:question] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:answer] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        NSString* link = [links objectAtIndex:indexPath.row];
        
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.textColor = [UIColor blueColor];
        cell.text = link;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.font = [UIFont systemFontOfSize:14];
        cell.lineBreakMode = UILineBreakModeMiddleTruncation;
        return cell;
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else if (indexPath.section == 1) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else {
        NSString* link = [links objectAtIndex:indexPath.row];
        if ([link rangeOfString:@"@"].length > 0) {
            link = [NSString stringWithFormat:@"mailto:%@", link];
        }
        
        NSURL* url = [NSURL URLWithString:link];
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:question accessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        return [WrappableCell height:answer accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Question", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Answer", nil);
    } else if (section == 2 && links.count > 0) {
        return NSLocalizedString(@"Useful Links", nil);
    }
    
    return nil;
}

@end