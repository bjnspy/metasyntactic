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

#import "AbstractApplication.h"
#import "AbstractNavigationController.h"
#import "MetasyntacticSharedApplication.h"
#import "MetasyntacticStockImages.h"
#import "OperationQueue.h"
#import "ViewControllerUtilities.h"

@interface AbstractTableViewController()
@property (retain) NSArray* visibleIndexPaths;
@property BOOL visible;
@end


@implementation AbstractTableViewController

@synthesize searchDisplayController;
@synthesize visibleIndexPaths;
@synthesize visible;

- (void) dealloc {
  self.searchDisplayController = nil;
  self.visibleIndexPaths = nil;
  self.visible = NO;

  [super dealloc];
}


- (AbstractNavigationController*) abstractNavigationController {
  return (id)self.navigationController;
}


- (void) didReceiveMemoryWarningWorker {
}


- (void) didReceiveMemoryWarning {
  if (visible) {
    return;
  }

  if (readonlyMode) {
    return;
  }

  // Store the currently visible cells so we can scroll back to them when
  // we're reloaded.
  self.visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

  [self didReceiveMemoryWarningWorker];

  [super didReceiveMemoryWarning];
}


- (void) onBeforeReloadTableViewData { }
- (void) onAfterReloadTableViewData { }
- (void) onBeforeReloadVisibleCells { }
- (void) onAfterReloadVisibleCells { }
- (void) onBeforeViewControllerPushed { }
- (void) onAfterViewControllerPushed { }
- (void) onBeforeViewControllerPopped { }
- (void) onAfterViewControllerPopped { }


- (void) reloadTableViewData {
  if (!visible) {
    return;
  }

  if (self.tableView.editing) {
    return;
  }

  if (readonlyMode) {
    return;
  }

  [self onBeforeReloadTableViewData];
  {
    [self.tableView reloadData];

    if (visibleIndexPaths.count > 0) {
      NSIndexPath* path = [visibleIndexPaths objectAtIndex:0];
      if (path.section >= 0 && path.section < self.tableView.numberOfSections &&
          path.row >= 0 && path.row < [self.tableView numberOfRowsInSection:path.section]) {
        [self.tableView scrollToRowAtIndexPath:[visibleIndexPaths objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
      }

      self.visibleIndexPaths = nil;
    }

    if (searchDisplayController.active) {
      if ([searchDisplayController respondsToSelector:@selector(reloadTableViewData)]) {
        [(id)searchDisplayController reloadTableViewData];
      }
    }
  }
  [self onAfterReloadTableViewData];
}


- (void) reload:(id) sender {
}


- (void) reloadVisibleCells {
  if (!visible) {
    return;
  }

  if (self.tableView.editing) {
    return;
  }

  if (readonlyMode) {
    return;
  }

  [self onBeforeReloadVisibleCells];
  {
    [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
    if (searchDisplayController.active) {
      if ([searchDisplayController respondsToSelector:@selector(reloadVisibleCells)]) {
        [(id)searchDisplayController reloadVisibleCells];
      }
    }
  }
  [self onAfterReloadVisibleCells];
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];

  if (!onBeforeViewControllerPushedCalled) {
    onBeforeViewControllerPushedCalled = YES;
    [self onBeforeViewControllerPushed];
  }

  self.visible = YES;
  [self reloadTableViewData];
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];

  if (!onAfterViewControllerPushedCalled) {
    onAfterViewControllerPushedCalled = YES;
    [self onAfterViewControllerPushed];
  }

  [MetasyntacticSharedApplication saveNavigationStack:self.navigationController];
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  self.visible = NO;
  if (![self.navigationController.viewControllers containsObject:self]) {
    [self onBeforeViewControllerPopped];
  }
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
  if (self.navigationController == nil) {
    [self onAfterViewControllerPopped];
  }
}


- (void) scrollViewDidEndDragging:(UIScrollView*) scrollView
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

  if (self.tableView.dragging || self.tableView.decelerating || self.tableView.tracking) {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:1];
    return;
  }

  [self performSelector:subclassSelector];
}


- (void) majorRefresh {
  [self refreshWithSelector:@selector(majorRefresh)
           subclassSelector:@selector(reloadTableViewData)];
}


- (void) minorRefresh {
  [self refreshWithSelector:@selector(minorRefresh)
           subclassSelector:@selector(reloadVisibleCells)];
}


- (void) setupTitleLabel {
  [ViewControllerUtilities setupTitleLabel:self];
}


- (BOOL) isGroupedStyle {
  return self.tableView.style == UITableViewStyleGrouped;
}


- (BOOL) isPlainStyle {
  return self.tableView.style == UITableViewStylePlain;
}


- (BOOL) hasOverriddenBackground {
  return self.abstractNavigationController.backgroundImage != nil && self.isGroupedStyle;
}


- (void) loadView {
  [super loadView];
  [self setupTitleLabel];
  
  if (self.hasOverriddenBackground) {
    self.view.backgroundColor = [UIColor clearColor];
  }
}


- (void) setTitle:(NSString*) text {
  BOOL changed = text.length == 0 || ![text isEqual:self.title];
  [super setTitle:text];

  if (changed) {
    [self setupTitleLabel];
  }
}


- (void) onRotate {
  [self setupTitleLabel];
}


- (void) tableView:(UITableView*) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (UIView*)       tableView:(UITableView*) tableView
     viewForHeaderInSection:(NSInteger) section {
  UIColor* groupedHeaderColor = [AbstractApplication tableViewGroupedHeaderColor];
  if (groupedHeaderColor != nil) {
    NSString* text = [self tableView:tableView titleForHeaderInSection:section];
    if (text.length > 0) {
      UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(19, 7, 0, 0)] autorelease];
      label.text = text;
      label.font = [UIFont boldSystemFontOfSize:17];
      label.textColor = groupedHeaderColor;
      label.opaque = NO;
      label.backgroundColor = [UIColor clearColor];
      [label sizeToFit];
      
      
      UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)] autorelease];
      view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      view.backgroundColor = [UIColor clearColor];
      
      [view addSubview:label];
      [view sizeToFit];
      
      return view;
    }
  }
  
  return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
    UIView* view = [self tableView:tableView viewForHeaderInSection:section];
    if (view != nil) {
      return view.frame.size.height;
    }
  }
  
  return -1;
}

@end
