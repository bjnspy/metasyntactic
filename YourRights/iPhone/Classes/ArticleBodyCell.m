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

#import "ArticleBodyCell.h"

#import "Item.h"

@interface ArticleBodyCell()
@property (retain) Item* item;
@property (retain) UILabel* label;
@end


@implementation ArticleBodyCell

@synthesize item;
@synthesize label;

- (void) dealloc {
  self.item = nil;
  self.label = nil;

  [super dealloc];
}


- (id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.label = [[[UILabel alloc] init] autorelease];
    label.font = [FontCache helvetica14];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = RGBUIColor(247, 247, 247);

    [self.contentView addSubview:label];
  }

  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  label.text = item.description;

  CGFloat width = self.frame.size.width;
  width -= (2 * groupedTableViewMargin) + (2 * 10);
  if (item.link.length != 0) {
    width -= 25;
  }

  CGRect rect = CGRectMake(10, 5, width, [ArticleBodyCell height:item] - 10);
  label.frame = rect;
}


+ (CGFloat) height:(Item*) item {
  CGFloat width;
  if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }
  width -= (2 * [self groupedTableViewMargin]) + (2 * 10);
  if (item.link.length != 0) {
    width -= 25;
  }

  CGSize size = CGSizeMake(width, 2000);
  size = [item.description sizeWithFont:[FontCache helvetica14]
                      constrainedToSize:size
                          lineBreakMode:UILineBreakModeWordWrap];

  return size.height + 10;
}

@end
