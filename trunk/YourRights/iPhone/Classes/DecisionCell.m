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

#import "DecisionCell.h"

#import "Decision.h"
#import "GreatestHitsViewController.h"

@interface DecisionCell()
@property (retain) Decision* decision;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* synopsisLabel;
@property (retain) UILabel* categoryLabel;
@end


@implementation DecisionCell

@synthesize decision;
@synthesize titleLabel;
@synthesize synopsisLabel;
@synthesize categoryLabel;

- (void) dealloc {
  self.decision = nil;
  self.titleLabel = nil;
  self.synopsisLabel = nil;
  self.categoryLabel = nil;

  [super dealloc];
}

- (id) initWithReuseIdentifier:(NSString*)reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 0, 20)] autorelease];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.adjustsFontSizeToFitWidth = YES;

    self.synopsisLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 26, 0, 12)] autorelease];
    synopsisLabel.font = [UIFont systemFontOfSize:12];
    synopsisLabel.textColor = [UIColor darkGrayColor];
    synopsisLabel.numberOfLines = 0;
    synopsisLabel.lineBreakMode = UILineBreakModeWordWrap;

    self.categoryLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    categoryLabel.font = [UIFont systemFontOfSize:12];
    categoryLabel.textColor = [UIColor darkGrayColor];
    categoryLabel.textAlignment = UITextAlignmentRight;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:synopsisLabel];
    [self.contentView addSubview:categoryLabel];
  }
  return self;
}


+ (CGFloat) width:(Decision*) decision {
  CGFloat width;
  if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    width = [UIScreen mainScreen].bounds.size.height;
  } else {
    width = [UIScreen mainScreen].bounds.size.width;
  }
  width -= 35;

  return width;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGFloat width = [DecisionCell width:decision];

  CGRect titleFrame = titleLabel.frame;
  titleFrame.size.width = width;
  titleLabel.frame = titleFrame;

  CGSize size = [synopsisLabel.text sizeWithFont:synopsisLabel.font constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:synopsisLabel.lineBreakMode];
  CGRect synopsisFrame = synopsisLabel.frame;
  synopsisFrame.size = size;
  synopsisLabel.frame = synopsisFrame;

  CGRect categoryFrame = categoryLabel.frame;
  categoryFrame.origin.y = synopsisFrame.origin.y + synopsisFrame.size.height;
  categoryFrame.size.width = width;
  categoryLabel.frame = categoryFrame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  if (selected) {
    titleLabel.textColor = [UIColor whiteColor];
    synopsisLabel.textColor = [UIColor whiteColor];
    categoryLabel.textColor = [UIColor whiteColor];
  } else {
    titleLabel.textColor = [UIColor blackColor];
    synopsisLabel.textColor = [UIColor darkGrayColor];
    categoryLabel.textColor = [UIColor darkGrayColor];
  }
}

- (void) setDecision:(Decision*) decision_ owner:(GreatestHitsViewController*) owner {
  self.decision = decision_;

  if ([owner sortingByCategory]) {
    categoryLabel.text = @"";
  } else {
    categoryLabel.text = [Decision categoryString:decision.category];
  }
  [categoryLabel sizeToFit];

  synopsisLabel.text = decision.synopsis;

  if ([owner sortingByYear]) {
    titleLabel.text = decision.title;
  } else {
    titleLabel.text = [NSString stringWithFormat:@"%@ (%d)", decision.title, decision.year];
  }
  [titleLabel sizeToFit];

  [self setNeedsLayout];
}



+ (CGFloat) height:(Decision*) decision owner:(GreatestHitsViewController*) owner {
  CGFloat width = [self width:decision];
  CGSize size = [decision.synopsis sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:UILineBreakModeWordWrap];

  CGFloat height = 26/*top of title */ + size.height + 4/*+2 on the top and bottom*/;
  if (![owner sortingByCategory]) {
    height += 14/*categoryLabel*/;
  }

  return height;
}

@end
