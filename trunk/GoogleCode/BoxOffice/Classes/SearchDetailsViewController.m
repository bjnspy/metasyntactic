// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
