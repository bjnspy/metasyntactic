//
//  UnitedStatesConstitutionViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UnitedStatesConstitutionViewController.h"

#import "Amendment.h"
#import "Article.h"
#import "AutoResizingCell.h"
#import "Constitution.h"
#import "ConstitutionAmendmentViewController.h"
#import "ConstitutionArticleViewController.h"

@interface UnitedStatesConstitutionViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Constitution* constitution;
@end

@implementation UnitedStatesConstitutionViewController

@synthesize navigationController;
@synthesize constitution;

- (void)dealloc {
    self.navigationController = nil;
    self.constitution = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                       constitution:(Constitution*) constitution_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.constitution = constitution_;
        self.title = constitution.country;
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return constitution.articles.count;
    } else if (section == 2) {
        return constitution.amendments.count;
    }
    
    return 0;
}


- (UITableViewCell*) cellForInformationRow:(NSInteger) row {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    if (row == 0) {
        cell.text = NSLocalizedString(@"Preamble", nil);
    } else {
        cell.text = NSLocalizedString(@"Signers", nil);
    }
    
    return cell;
}


- (UITableViewCell*) cellForArticlesRow:(NSInteger) row {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    AutoResizingCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    Article* article = [constitution.articles objectAtIndex:row];
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%d. %@", nil), row + 1, article.title];
    
    return cell;
}


- (UITableViewCell*) cellForAmendmentsRow:(NSInteger) row {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    AutoResizingCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    Amendment* amendment = [constitution.amendments objectAtIndex:row];
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%d. %@", nil), row + 1, amendment.synopsis];
    
    return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self cellForInformationRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self cellForArticlesRow:indexPath.row];
    } else {
        return [self cellForAmendmentsRow:indexPath.row];
    }
}


- (void) didSelectInformationRow:(NSInteger) row {
    
}


- (void) didSelectArticlesRow:(NSInteger) row {
    Article* article = [constitution.articles objectAtIndex:row];
    ConstitutionArticleViewController* controller = [[[ConstitutionArticleViewController alloc] initWithNavigationController:navigationController article:article] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void) didSelectAmendmentsRow:(NSInteger) row {
    Amendment* amendment = [constitution.amendments objectAtIndex:row];
    ConstitutionAmendmentViewController* controller = [[[ConstitutionAmendmentViewController alloc] initWithNavigationController:navigationController amendment:amendment] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self didSelectInformationRow:indexPath.row];
    } else if (indexPath.section == 1) {
        [self didSelectArticlesRow:indexPath.row];
    } else {
        [self didSelectAmendmentsRow:indexPath.row];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Information", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Articles", nil);
    } else {
        return NSLocalizedString(@"Amendments", nil);
    }
    
    return nil;
}


@end

