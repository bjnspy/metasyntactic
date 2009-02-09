//
//  ConstitutionArticleViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConstitutionArticleViewController.h"

#import "Article.h"
#import "Section.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionArticleViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Article* article;
@end


@implementation ConstitutionArticleViewController

@synthesize navigationController;
@synthesize article;

- (void) dealloc {
    self.navigationController = nil;
    self.article = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                            article:(Article*) article_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.article = article_;
        self.navigationItem.titleView =
        [ViewControllerUtilities viewControllerTitleLabel:article.title];
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return article.sections.count + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
    Section* section = [article.sections objectAtIndex:row];
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.text] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (UITableViewCell*) cellForLinksRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
    cell.text = @"Wikipedia";
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < article.sections.count) {
        return [self cellForSectionRow:indexPath.section];
    } else {
        return [self cellForLinksRow:indexPath.row];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < article.sections.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        [navigationController pushBrowser:article.link animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section < article.sections.count) {
        return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
    } else {
        return NSLocalizedString(@"Links", nil);
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < article.sections.count) {
        Section* section = [article.sections objectAtIndex:indexPath.section];
        
        NSString* text = section.text;
        
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}



@end
