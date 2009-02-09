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
    return article.sections.count;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Section* section = [article.sections objectAtIndex:indexPath.section];
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.text] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
}


- (CGFloat)         tableView:(UITableView*) tableView
       heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    Section* section = [article.sections objectAtIndex:indexPath.section];
    
    NSString* text = section.text;
    
    return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
}



@end
