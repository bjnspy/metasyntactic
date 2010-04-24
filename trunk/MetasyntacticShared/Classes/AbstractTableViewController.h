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

#import "AbstractViewController.h"

@interface AbstractTableViewController : UITableViewController<UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {
@protected
  BOOL visible;
  BOOL readonlyMode;
  NSArray* visibleIndexPaths;
  UISearchDisplayController* searchDisplayController;

@private
  ViewControllerState* state;
}

- (void) majorRefresh;
- (void) minorRefresh;

/* @protected */
@property (retain) UISearchDisplayController* searchDisplayController;

- (AbstractNavigationController*) abstractNavigationController;

- (void) didReceiveMemoryWarningWorker;

- (void) onBeforeReloadTableViewData;
- (void) onAfterReloadTableViewData;
- (void) onBeforeReloadVisibleCells;
- (void) onAfterReloadVisibleCells;
- (void) onBeforeViewControllerPushed;
- (void) onAfterViewControllerPushed;
- (void) onBeforeViewControllerPopped;
- (void) onAfterViewControllerPopped;

- (void) setupTitleLabel;

- (BOOL) hasOverriddenBackground;

- (void) playMovie:(NSString*) address;

- (UIBarButtonItem*) createActivityIndicator;
- (UIBarButtonItem*) createInfoButton:(SEL) action;

- (void) openMailTo:(NSString*) recipient
        withSubject:(NSString*) subject
               body:(NSString*) body
             isHTML:(BOOL) isHtml;

- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end
