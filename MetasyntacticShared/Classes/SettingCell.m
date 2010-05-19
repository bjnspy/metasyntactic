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

#import "SettingCell.h"

#import "ColorCache.h"

@interface SettingCell()
@property (retain) UILabel* separatorLine;
@property (copy) NSString* value;
@end


@implementation SettingCell

@synthesize separatorLine;
@synthesize value;
@synthesize placeholder;

- (void) dealloc {
  self.separatorLine = nil;
  self.value = nil;
  self.placeholder = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleValue1
                   reuseIdentifier:reuseIdentifier])) {
    self.separatorLine = [[[UILabel alloc] init] autorelease];
  }

  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGRect separatorFrame = CGRectMake(0, -1, self.contentView.frame.size.width, 1);
  separatorLine.frame = separatorFrame;
}


- (void) setValueColor {
  if (value.length > 0) {
    self.detailTextLabel.textColor = [ColorCache commandColor];
  } else {
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
  }
}


- (void) setCellValue:(NSString*) text {
  self.value = text;

  if (value.length > 0) {
    self.detailTextLabel.text = value;
  } else {
    self.detailTextLabel.text = placeholder;
  }

  [self setValueColor];
}


- (void) setHidesSeparator:(BOOL) hideSeparator {
  [separatorLine removeFromSuperview];
  if (hideSeparator) {
    [self.contentView addSubview:separatorLine];
  }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
  [super setSelected:selected animated:animated];
  if (selected) {
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];
  } else {
    self.textLabel.textColor = [UIColor blackColor];
    [self setValueColor];
  }
}

@end
