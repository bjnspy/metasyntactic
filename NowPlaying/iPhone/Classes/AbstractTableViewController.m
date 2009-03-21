// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AbstractTableViewController.h"

#import "AbstractNavigationController.h"
#import "Model.h"

@interface AbstractTableViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) NSArray* visibleIndexPaths;
@end


@implementation AbstractTableViewController

@synthesize navigationController;
@synthesize visibleIndexPaths;

- (void) dealloc {
    self.navigationController = nil;
    self.visibleIndexPaths = nil;

    [super dealloc];
}


- (id)       initWithStyle:(UITableViewStyle) style_
      navigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:style_]) {
        self.navigationController = navigationController_;
    }

    return self;
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    visible = YES;
    [self.model saveNavigationStack:navigationController];
}


- (void) viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    visible = NO;
}


- (void) didReceiveMemoryWarningWorker {
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    // Store the currently visible cells so we can scroll back to them when
    // we're reloaded.
    self.visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

    [self didReceiveMemoryWarningWorker];

    [super didReceiveMemoryWarning];
}


- (void) reloadTableViewData {
    [self.tableView reloadData];

    if (visibleIndexPaths.count > 0) {
        NSIndexPath* path = [visibleIndexPaths objectAtIndex:0];
        if (path.section >= 0 && path.section < self.tableView.numberOfSections &&
            path.row >= 0 && path.row < [self.tableView numberOfRowsInSection:path.section]) {
            [self.tableView scrollToRowAtIndexPath:[visibleIndexPaths objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }

        self.visibleIndexPaths = nil;
    }
}

@end