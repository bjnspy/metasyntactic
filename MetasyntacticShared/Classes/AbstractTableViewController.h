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
