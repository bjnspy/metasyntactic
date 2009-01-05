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
@property (retain) NSArray* links;
@end


@implementation QuestionsViewController

@synthesize sectionTitle;
@synthesize preamble;
@synthesize questions;
@synthesize otherResources;
@synthesize links;

- (void)dealloc {
    self.sectionTitle = nil;
    self.preamble = nil;
    self.questions = nil;
    self.otherResources = nil;
    self.links = nil;

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
        self.links = [Model linksForSectionTitle:sectionTitle];
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return preamble.length == 0 ? 0 : 1;
    } else if (section == 1) {
        return questions.count;
    } else if (section == 2) {
        return otherResources.count;
    } else {
        return links.count;
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
    } else if (indexPath.section == 2) {
        NSString* text = [otherResources objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
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


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:preamble accessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        return [WrappableCell height:[questions objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else if (indexPath.section == 2) {
        return [WrappableCell height:[otherResources objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else if (indexPath.section == 1) {
        NSString* question = [questions objectAtIndex:indexPath.row];
        NSString* answer = [Model answerForQuestion:question withSectionTitle:sectionTitle];
        AnswerViewController* controller = [[[AnswerViewController alloc] initWithSectionTitle:sectionTitle question:question answer:answer] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 2) {
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


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && preamble.length > 0) {
        return NSLocalizedString(@"Information", nil);
    } else if (section == 1) {
        if (preamble.length > 0 || otherResources.count > 0 || links.count > 0) {
            return NSLocalizedString(@"Questions", nil);
        }
    } else if (section == 2 && otherResources.count > 0) {
        return NSLocalizedString(@"Other Resources", nil);
    } else if (section == 3 && links.count > 0) {
        return NSLocalizedString(@"Useful Links", nil);
    }
    
    return nil;
}


@end
