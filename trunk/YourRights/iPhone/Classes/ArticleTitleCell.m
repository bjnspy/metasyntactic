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

#import "ArticleTitleCell.h"

#import "Item.h"

@interface ArticleTitleCell()
@property (retain) UILabel* titleLabel;
@end

@implementation ArticleTitleCell

@synthesize titleLabel;

- (void) dealloc {
  self.titleLabel = nil;

  [super dealloc];
}


- (id) initWithStyle:(UITableViewCellStyle) style
     reuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = RGBUIColor(247, 247, 247);

    [self.contentView addSubview:titleLabel];
  }
  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGRect contentFrame = self.contentView.frame;

  CGRect frame;

  frame = titleLabel.frame;
  frame.size.width = contentFrame.size.width - 16;
  frame.size.height = contentFrame.size.height - 10;
  titleLabel.frame = frame;
}


- (void) setItem:(Item*) item {
  titleLabel.text = item.title;

  CGRect frame;

  frame = titleLabel.frame;
  frame.origin.y = 7;
  frame.origin.x = 8;
  titleLabel.frame = frame;
}

@end
