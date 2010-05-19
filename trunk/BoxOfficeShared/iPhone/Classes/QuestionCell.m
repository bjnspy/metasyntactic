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

#import "QuestionCell.h"

#import "BoxOfficeStockImages.h"

@interface QuestionCell()
@property (retain) UILabel* contentLabel;
@end


@implementation QuestionCell

@synthesize contentLabel;

- (void) dealloc {
  self.contentLabel = nil;
  [super dealloc];
}


+ (UIFont*) contentFont {
  return [UIFont systemFontOfSize:16];
}


- (id) initWithQuestion:(BOOL) question
        reuseIdentifier:(NSString*) reuseIdentifier
    tableViewController:(UITableViewController*) tableViewController {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:reuseIdentifier
               tableViewController:tableViewController])) {
    self.backgroundColor = [ColorCache helpBlue];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.contentLabel = [[[UILabel alloc] init] autorelease];
    contentLabel.font = [QuestionCell contentFont];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.backgroundColor = [UIColor clearColor];
    [contentLabel sizeToFit];

    CGRect contentFrame = contentLabel.frame;
    contentFrame.origin.y = 4;
    contentFrame.origin.x = question ? 75 : 20;
    contentLabel.frame = contentFrame;

    [self.contentView addSubview:contentLabel];

    if (question) {
      UIImage* image = BoxOfficeStockImage(@"QuestionBalloon.png");
      UIImage* stretchedImage = [image stretchableImageWithLeftCapWidth:85 topCapHeight:18];
      self.backgroundView = [[[UIImageView alloc] initWithImage:stretchedImage] autorelease];
    } else {
      UIImage* image = BoxOfficeStockImage(@"AnswerBalloon.png");
      UIImage* stretchedImage = [image stretchableImageWithLeftCapWidth:85 topCapHeight:18];
      self.backgroundView = [[[UIImageView alloc] initWithImage:stretchedImage] autorelease];
    }
  }

  return self;
}


- (void) setQuestionText:(NSString*) text {
  contentLabel.text = text;
}


- (CGFloat) height {
  CGFloat width = self.tableViewController.view.frame.size.width;

  width -= (50 + 60);

  CGSize contentSize = [contentLabel.text sizeWithFont:[QuestionCell contentFont]
                        constrainedToSize:CGSizeMake(width, 2000)
                            lineBreakMode:UILineBreakModeWordWrap];

  return contentSize.height + 4 + 8;
}


- (void) layoutSubviews {
  [super layoutSubviews];

  CGFloat height = [self height];

  CGRect contentFrame = contentLabel.frame;
  contentFrame.size.width = self.contentView.frame.size.width - (30 + 60);
  contentFrame.size.height = height - (4 + 8);

  contentLabel.frame = contentFrame;
}

@end
