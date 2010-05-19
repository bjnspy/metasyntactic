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

#import "ReviewBodyCell.h"

#import "Model.h"
#import "Review.h"

@interface ReviewBodyCell()
@property (retain) Review* reviewData;
@property (retain) UILabel* label;
@end


@implementation ReviewBodyCell

@synthesize reviewData;
@synthesize label;

- (void) dealloc {
  self.reviewData = nil;
  self.label = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
           tableViewController:(UITableViewController*) tableViewController {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:reuseIdentifier
               tableViewController:tableViewController])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.font = [FontCache helvetica14];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;

    [self.contentView addSubview:label];
  }

  return self;
}


- (BOOL) reviewHasLink {
  return reviewData.link.length > 0 && ![[Model model] isInReviewPeriod];
}


- (void) height:(CGFloat*) outHeight width:(CGFloat*) outWidth {
  CGFloat width = self.tableViewController.view.frame.size.width;
  width -= 2 * groupedTableViewMargin;
  width -= 2 * 10;

  if ([self reviewHasLink]) {
    width -= 25;
  }

  CGSize size = CGSizeMake(width, 2000);
  size = [reviewData.text sizeWithFont:[FontCache helvetica14]
                     constrainedToSize:size
                         lineBreakMode:UILineBreakModeWordWrap];

  *outWidth = width;
  *outHeight = size.height + 10;
}


- (CGFloat) height {
  CGFloat height, width;
  [self height:&height width:&width];
  return height;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  label.text = reviewData.text;

  CGFloat height, width;
  [self height:&height width:&width];

  CGRect rect = CGRectMake(10, 5, width, height - 10);
  label.frame = rect;
}


- (void) setReview:(Review*) review {
  self.reviewData = review;

  if ([self reviewHasLink]) {
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  } else {
    self.accessoryType = UITableViewCellAccessoryNone;
  }
}

@end
