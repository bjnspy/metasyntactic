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

#import "WrappableCell.h"

@interface WrappableCell()
@property (retain) NSString* title;
@property (retain) UILabel* label;
@end

@implementation WrappableCell

static UIFont* defaultFont;

+ (void) initialize {
  if (self == [WrappableCell class]) {
    defaultFont = [[UIFont boldSystemFontOfSize:18] retain];
  }
}

@synthesize title;
@synthesize label;

- (void) dealloc {
  self.title = nil;
  self.label = nil;

  [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil])) {
    self.title = title_;

    self.label = [[[UILabel alloc] init] autorelease];
    label.text = title;
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = defaultFont;

    [self.contentView addSubview:label];
  }

  return self;
}


- (void) setFont:(UIFont*) font {
  label.font = font;
}


- (void) layoutSubviews {
  [super layoutSubviews];
  CGRect frame = self.contentView.frame;

  CGFloat height =  [WrappableCell height:title accessoryType:self.accessoryType font:label.font] - 20;
  label.frame = CGRectMake(10, 10, frame.size.width - 20, height);
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  if (selected && self.selectionStyle != UITableViewCellSelectionStyleNone) {
    label.textColor = [UIColor whiteColor];
  } else {
    label.textColor = [UIColor blackColor];
  }
}


+ (CGFloat)  height:(NSString*) text
      accessoryType:(UITableViewCellAccessoryType) accessoryType
               font:(UIFont*) font {
  CGFloat width;
  if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }
  width -= 20; // normal content view

  if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
    width -= 10;
  }

  CGSize size = CGSizeMake(width, 50000);
  size = [text sizeWithFont:font
          constrainedToSize:size
              lineBreakMode:UILineBreakModeWordWrap];

  return size.height + 20;
}


+ (CGFloat) height:(NSString*) text accessoryType:(UITableViewCellAccessoryType) accessoryType {
  return [self height:text accessoryType:accessoryType font:defaultFont];
}


@end
