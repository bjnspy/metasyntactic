//
//  QuestionsViewController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuestionsViewController.h"

#import "Model.h"
#import "ViewControllerUtilities.h"

@interface QuestionsViewController()
@property (retain) NSString* sectionTitle;
@property (retain) NSArray* questions;
@end


@implementation QuestionsViewController

@synthesize sectionTitle;
@synthesize questions;

- (void)dealloc {
    self.sectionTitle = nil;
    self.questions = nil;
    [super dealloc];
}


- (id) initWithSectionTitle:(NSString*) sectionTitle_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.sectionTitle = sectionTitle_;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:[Model shortSectionTitleForSectionTitle:sectionTitle]];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
        self.questions = [Model questionsForSectionTitle:sectionTitle];
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return questions.count;
}


@end
