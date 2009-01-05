//
//  QuestionsViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuestionsViewController.h"

#import "AnswerViewController.h"
#import "Model.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface QuestionsViewController()
@property (copy) NSString* sectionTitle;
@property (copy) NSString* preamble;
@property (retain) NSArray* questions;
@property (retain) NSArray* otherResources;
@end


@implementation QuestionsViewController

@synthesize sectionTitle;
@synthesize preamble;
@synthesize questions;
@synthesize otherResources;

- (void)dealloc {
    self.sectionTitle = nil;
    self.preamble = nil;
    self.questions = nil;
    self.otherResources = nil;
    [super dealloc];
}


- (id) initWithSectionTitle:(NSString*) sectionTitle_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.sectionTitle = sectionTitle_;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:[Model shortSectionTitleForSectionTitle:sectionTitle]];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
        self.preamble = [Model preambleForSectionTitle:sectionTitle];
        self.questions = [Model questionsForSectionTitle:sectionTitle];
        self.otherResources = [Model otherResourcesForSectionTitle:sectionTitle];
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return preamble.length == 0 ? 0 : 1;
    } else if (section == 1) {
        return questions.count;
    } else {
        return otherResources.count;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:preamble] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.section == 1) {
        NSString* text = [questions objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        NSString* text = [otherResources objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:preamble accessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        return [WrappableCell height:[questions objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        return [WrappableCell height:[otherResources objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryNone];
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else if (indexPath.section == 1) {
        NSString* question = [questions objectAtIndex:indexPath.row];
        NSString* answer = [Model answerForQuestion:question withSectionTitle:sectionTitle];
        AnswerViewController* controller = [[[AnswerViewController alloc] initWithQuestion:question answer:answer] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];   
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && preamble.length > 0) {
        return NSLocalizedString(@"Information", nil);
    } else if (section == 1) {
        if (preamble.length > 0 || otherResources.count > 0) {
            return NSLocalizedString(@"Questions", nil);
        }
    } else if (section == 2 && otherResources.count > 0) {
        return NSLocalizedString(@"Other Resources", nil);
    }
    
    return nil;
}


@end
