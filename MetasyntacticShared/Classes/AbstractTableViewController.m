// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "AbstractTableViewController.h"

#import "AbstractNavigationController.h"
#import "MetasyntacticSharedApplication.h"
#import "NSArray+Utilities.h"
#import "OperationQueue.h"
#import "StyleSheet.h"
#import "UIColor+Utilities.h"
#import "UIScrollView+Utilities.h"
#import "ViewControllerState.h"
#import "ViewControllerUtilities.h"

@interface AbstractTableViewController()
@property (retain) NSArray* visibleIndexPaths;
@property BOOL visible;
@property (retain) ViewControllerState* state;
@end


@implementation AbstractTableViewController

@synthesize searchDisplayController;
@synthesize visibleIndexPaths;
@synthesize visible;
@synthesize state;

- (void) dealloc {
  self.searchDisplayController = nil;
  self.visibleIndexPaths = nil;
  self.visible = NO;
  self.state = nil;

  [super dealloc];
}


- (id) initWithStyle:(UITableViewStyle) style {
  if ((self = [super initWithStyle:style])) {
    self.state = [[[ViewControllerState alloc] init] autorelease];
  }

  return self;
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


- (void) playMovie:(NSString*) address {
  [state playMovie:address viewController:self];
}


- (void) onBeforeReloadTableViewData { }
- (void) onAfterReloadTableViewData { }
- (void) onBeforeReloadVisibleCells { }
- (void) onAfterReloadVisibleCells { }
- (void) onBeforeViewControllerPushed { }
- (void) onAfterViewControllerPushed { }
- (void) onAfterViewControllerPopped { }
- (void) onBeforeViewControllerPopped { }


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
      NSIndexPath* path = visibleIndexPaths.firstObject;
      if (path.section >= 0 && path.section < self.tableView.numberOfSections &&
          path.row >= 0 && path.row < [self.tableView numberOfRowsInSection:path.section]) {
        [self.tableView scrollToRowAtIndexPath:visibleIndexPaths.firstObject atScrollPosition:UITableViewScrollPositionNone animated:NO];
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


- (BOOL) isGroupedStyle {
  return self.tableView.style == UITableViewStyleGrouped;
}


- (BOOL) isPlainStyle {
  return self.tableView.style == UITableViewStylePlain;
}


- (void) setupSearchHeaderBackgroundColor {
  if (self.isPlainStyle &&
      [self.tableView.tableHeaderView isKindOfClass:[UISearchBar class]]) {
    NSString* key = [NSString stringWithFormat:@"%@%@", @"tableHeader", @"BackgroundColor"];
    [self.tableView setValue:[StyleSheet tableViewSearchHeaderBackgroundColor]
                      forKey:key];
  }
}


- (void) viewWillAppear:(BOOL) animated {
  NSLog(@"%d \"%@\" viewWillAppear", self, self.title);
  [super viewWillAppear:animated];
  NSAssert(state != nil, @"");
  [state viewController:self willAppear:animated];

  self.visible = YES;
  [self reloadTableViewData];
}


- (void) viewDidAppear:(BOOL) animated {
  NSLog(@"%d \"%@\" viewDidAppear", self, self.title);
  [super viewDidAppear:animated];
  NSAssert(state != nil, @"");
  [state viewController:self didAppear:animated];

  [MetasyntacticSharedApplication saveNavigationStack:self.navigationController];
  [self setupSearchHeaderBackgroundColor];
}


- (void) viewWillDisappear:(BOOL) animated {
  NSLog(@"%d \"%@\" viewWillDisappear", self, self.title);
  [super viewWillDisappear:animated];
  self.visible = NO;
  NSAssert(state != nil, @"");
  [state viewController:self willDisappear:animated];
}


- (void) viewDidDisappear:(BOOL) animated {
  NSLog(@"%d \"%@\" viewDidDisappear", self, self.title);
  [super viewDidDisappear:animated];
  NSAssert(state != nil, @"");
  [state viewController:self didDisappear:animated];
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

  if (self.tableView.isMoving) {
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


- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [self setupTitleLabel];
}


- (void) tableView:(UITableView*) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (UIView*)       tableView:(UITableView*) tableView
     viewForHeaderInSection:(NSInteger) section {
  if (self.isGroupedStyle &&
      [self respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
    UIColor* groupedHeaderColor = [StyleSheet tableViewGroupedHeaderColor];
    if (groupedHeaderColor != nil) {
      NSString* text = [self tableView:tableView titleForHeaderInSection:section];
      if (text.length > 0) {
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(19, 7, 320 - 2 * 19, 0)] autorelease];
        label.text = text;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = groupedHeaderColor;
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [label sizeToFit];


        UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, label.frame.size.height + 15)] autorelease];
        view.backgroundColor = [UIColor clearColor];

        [view addSubview:label];
        [view sizeToFit];

        return view;
      }
    }
  }

  return nil;
}


- (CGFloat)        tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if ([self respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
    UIView* view = [self tableView:tableView viewForHeaderInSection:section];
    if (view != nil) {
      return view.frame.size.height;
    }
  }

  return -1;
}


- (UILabel*) createGroupedFooterLabel:(UIColor*) textColor
                                 text:(NSString*) text {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
  label.text = text;
  label.textAlignment = UITextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = textColor;
  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.numberOfLines = 0;
  [label sizeToFit];
  return label;
}


- (UIView*) createGroupedFooterLabelView:(UILabel*) label {
  UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, label.frame.size.height + 6 + 11)] autorelease];
  view.backgroundColor = [UIColor clearColor];

  CGRect frame = label.frame;
  frame.origin.y = 6;
  frame.size.width = 320;
  label.frame = frame;

  [view addSubview:label];
  [view sizeToFit];

  return view;
}


- (UIView*)       tableView:(UITableView*) tableView
     viewForFooterInSection:(NSInteger) section {
  if (self.isGroupedStyle &&
      [self respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
    UIColor* groupedFooterColor = [StyleSheet tableViewGroupedFooterColor];
    if (groupedFooterColor != nil) {
      NSString* text = [self tableView:tableView titleForFooterInSection:section];
      if (text.length > 0) {
        UILabel* label = [self createGroupedFooterLabel:groupedFooterColor text:text];
        return [self createGroupedFooterLabelView:label];
      }
    }
  }

  return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if ([self respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
    UIView* view = [self tableView:tableView viewForFooterInSection:section];
    if (view != nil) {
      return view.frame.size.height;
    }
  }

  return -1;
}


- (UIBarButtonItem*) createActivityIndicator {
  UIActivityIndicatorView* activityIndicatorView;

  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
  } else {
    activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  }
  CGRect frame = activityIndicatorView.frame;
  frame.size.width += 4;
  [activityIndicatorView startAnimating];

  UIView* activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
  [activityView addSubview:activityIndicatorView];

  return [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];
}


- (UIBarButtonItem*) createInfoButton:(SEL) action {
  UIButton* infoButton;
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
  } else {
    infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
  }

  [infoButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

  infoButton.contentMode = UIViewContentModeCenter;
  CGRect frame = infoButton.frame;
  frame.size.width += 4;
  infoButton.frame = frame;
  return [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) openMailTo:(NSString*) recipient
        withSubject:(NSString*) subject
               body:(NSString*) body
             isHTML:(BOOL) isHTML {
  MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc] init] autorelease];
  controller.mailComposeDelegate = self;

  if (recipient.length > 0) {
    [controller setToRecipients:[NSArray arrayWithObject:recipient]];
  }
  [controller setSubject:subject];
  [controller setMessageBody:body isHTML:isHTML];

  [self presentModalViewController:controller animated:YES];
}


- (void) mailComposeController:(MFMailComposeViewController*) controller
           didFinishWithResult:(MFMailComposeResult) result
                         error:(NSError*) error {
  [self dismissModalViewControllerAnimated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
  return [MetasyntacticSharedApplication shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
