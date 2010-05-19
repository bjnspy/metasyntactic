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

#import "AbstractCollapsedDetailsCell.h"

#import "MetasyntacticStockImages.h"

@implementation AbstractCollapsedDetailsCell

- (id) initWithTableViewController:(UITableViewController *)tableViewController {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
               tableViewController:tableViewController])) {
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];
    self.textLabel.textAlignment = UITextAlignmentCenter;

    UIImage* backgroundImage = [MetasyntacticStockImage(@"CollapsedDetailsBackground.png") stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    if (backgroundImage != nil) {
      self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
      self.textLabel.textColor = [UIColor whiteColor];
      self.textLabel.backgroundColor = [UIColor clearColor];
      self.textLabel.opaque = NO;
    }

    self.imageView.image = [MetasyntacticStockImages expandArrow];
  }

  return self;
}


- (CGFloat) height {
  return self.tableViewController.tableView.rowHeight - 14;
}

@end
