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

@interface AbstractImageCell : AbstractTableViewCell {
@private
  UIImageView* imageLoadingView;
  UIActivityIndicatorView* activityView;
  BOOL imageLoaded;

@protected
  UIImageView* imageView;

  UILabel* titleLabel;
  CGFloat titleWidth;
}

- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController;

// @protected
- (void) loadImage;
- (void) clearImage;
- (NSArray*) allLabels;

- (UILabel*) createTitleLabel:(NSString*) title yPosition:(NSInteger) yPosition;
- (UILabel*) createValueLabel:(NSInteger) yPosition forTitle:(UILabel*) titleLabel;

- (void) setCellImage:(UIImage*) image animated:(BOOL) animated;

@end
