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
@synthesize activityIndicator;
@synthesize activityView;

- (void) dealloc {
    self.navigationController = nil;
    self.activityIndicator = nil;
    self.activityView = nil;

    [super dealloc];
}

- (id)initWithNavigationController:(SearchNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                                target:self
                                                                                                action:@selector(onSearchButtonSelected:)] autorelease];

        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = self.activityIndicator.frame;
        frame.size.width += 10;

        self.activityView = [[[UIView alloc] initWithFrame:activityIndicator.frame] autorelease];
        [activityView addSubview:self.activityIndicator];
    }

    return self;
}

- (void) onSearchButtonSelected:(id) object {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (void) startActivityIndicator {
    [self.activityIndicator startAnimating];

    UIBarButtonItem* item =  [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

- (void) stopActivityIndicator {
    [self.activityIndicator stopAnimating];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

@end
