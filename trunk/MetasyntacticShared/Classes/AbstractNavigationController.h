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

@interface AbstractNavigationController : UINavigationController {
@protected
  BOOL visible;
  AbstractFullScreenImageListViewController* fullScreenImageListController;
}

- (UIImage*) backgroundImage;

- (void) majorRefresh;
- (void) minorRefresh;
- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
                             duration:(NSTimeInterval) duration;

- (void) pushBrowser:(NSString*) address animated:(BOOL) animated;
- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated;

- (void) pushFullScreenImageList:(AbstractFullScreenImageListViewController*) controller;
- (void) popFullScreenImageList;

- (void) pushMapWithCenter:(id<MapPoint>) center animated:(BOOL) animated;
- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations animated:(BOOL) animated;
- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations delegate:(id<MapViewControllerDelegate>) delegate animated:(BOOL) animated;

- (void) pushTweetController:(NSString*) tweet account:(AbstractTwitterAccount*) account;

@end
