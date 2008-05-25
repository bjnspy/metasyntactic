//
//  SearchDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchDetailsViewController.h"
#import "SearchNavigationController.h"

@implementation SearchDetailsViewController

@synthesize navigationController;

- (void)dealloc {
    self.navigationController = nil;
    [super dealloc];
}

- (id)initWithNavigationController:(SearchNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                target:self
                                                                                                action:@selector(onSearchButtonSelected:)] autorelease];
    }
    
    return self;
}

- (void) onSearchButtonSelected:(id) object {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

@end
