//
//  ConstitutionAmendmentViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConstitutionAmendmentViewController.h"

#import "Amendment.h"
#import "Section.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionAmendmentViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Amendment* amendment;
@end


@implementation ConstitutionAmendmentViewController

@synthesize navigationController;
@synthesize amendment;

- (void) dealloc {
    self.navigationController = nil;
    self.amendment = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                          amendment:(Amendment*) amendment_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.amendment = amendment_;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:amendment.synopsis];
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return amendment.sections.count + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < amendment.sections.count) {
        Section* section = [amendment.sections objectAtIndex:indexPath.section];
        WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.text = @"Wikipedia";
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < amendment.sections.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        [navigationController pushBrowser:amendment.link animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section < amendment.sections.count) {
        if (section == 0) {
            if (amendment.sections.count == 1) {
                return [NSString stringWithFormat:@"%d", amendment.year];
            } else {
                return [NSString stringWithFormat:@"%d. Section %d", amendment.year, section + 1];
            }
        } else {
            return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
        }
    } else {
        return NSLocalizedString(@"Links", nil);
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < amendment.sections.count) {
        Section* section = [amendment.sections objectAtIndex:indexPath.section];
        
        NSString* text = section.text;
        
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end
