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

#import "MetasyntacticSharedApplication.h"
#import "OperationQueue.h"

@interface AbstractTableViewController()
@property (retain) NSArray* visibleIndexPaths;
@property BOOL visible;
@end


@implementation AbstractTableViewController

@synthesize visibleIndexPaths;
@synthesize visible;

- (void) dealloc {
  self.visibleIndexPaths = nil;
  self.visible = NO;
  
  [super dealloc];
}


- (AbstractNavigationController*) abstractNavigationController {
  return (id)self.navigationController;
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  [MetasyntacticSharedApplication saveNavigationStack:self.navigationController];
}


- (void) majorRefreshWorker {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) minorRefreshWorker {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  
  self.visible = YES;
  [self majorRefreshWorker];
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  self.visible = NO;
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
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
  if (!visible) {
    return;
  }
  
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


- (void) reload:(id) sender {
}


- (void) reloadVisibleCells {
  if (!visible) {
    return;
  }
  
  [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
}


- (void)scrollViewDidEndDragging:(UIScrollView*) scrollView
                  willDecelerate:(BOOL) willDecelerate {
  if (willDecelerate) {
    [[OperationQueue operationQueue] temporarilySuspend];
  }
}


- (void) refreshWithSelector:(SEL) selector subclassSelector:(SEL) subclassSelector {
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:selector
                                             object:nil];
  
  if (!visible) {
    return;
  }
  
  if (self.tableView.dragging || self.tableView.decelerating) {
    [self performSelector:selector withObject:nil afterDelay:1];
    return;
  }
  
  [self performSelector:subclassSelector];
}


- (void) majorRefresh {
  [self refreshWithSelector:@selector(majorRefresh) subclassSelector:@selector(majorRefreshWorker)];
}


- (void) minorRefresh {
  [self refreshWithSelector:@selector(minorRefresh) subclassSelector:@selector(minorRefreshWorker)];
}

@end
