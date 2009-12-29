// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AbstractImageCell.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"


@interface AbstractImageCell()
@property (retain) UIImageView* imageLoadingView;
@property (retain) UIImageView* imageView;
@property (retain) UIActivityIndicatorView* activityView;
@property (retain) UILabel* titleLabel;
@end


@implementation AbstractImageCell

@synthesize imageLoadingView;
@synthesize imageView;
@synthesize activityView;
@synthesize titleLabel;

- (void) dealloc {
  self.imageLoadingView = nil;
  self.imageView = nil;
  self.activityView = nil;
  self.titleLabel = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:reuseIdentifier])) {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 20)] autorelease];

    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumFontSize = 14;

    if ([Model model].loadingIndicatorsEnabled) {
      self.imageLoadingView = [[[UIImageView alloc] initWithImage:[BoxOfficeStockImages imageLoading]] autorelease];
    } else {
      self.imageLoadingView = [[[UIImageView alloc] initWithImage:[BoxOfficeStockImages imageLoadingNeutral]] autorelease];
    }
    imageLoadingView.contentMode = UIViewContentModeScaleAspectFit;

    self.imageView = [[[UIImageView alloc] init] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.alpha = 0;

    CGRect imageFrame = imageLoadingView.frame;
    imageFrame.size.width = (NSInteger)(imageFrame.size.width * SMALL_POSTER_HEIGHT / imageFrame.size.height);
    imageFrame.size.height = (NSInteger) SMALL_POSTER_HEIGHT;
    imageView.frame = imageLoadingView.frame = imageFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

    self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    activityView.hidesWhenStopped = YES;
    CGRect frame = activityView.frame;
    frame.origin.x = 25;
    frame.origin.y = 40;
    activityView.frame = frame;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:imageLoadingView];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:activityView];
  }

  return self;
}


- (UIImage*) loadImageWorker AbstractMethod;


- (void) prioritizeImage AbstractMethod;


- (void) prepareForReuse {
  [super prepareForReuse];
  if (![Model model].loadingIndicatorsEnabled) {
    [activityView stopAnimating];
  }
}


- (void) startAnimating {
  if ([Model model].loadingIndicatorsEnabled) {
    [activityView startAnimating];
  }
}


- (void) setCellImage:(UIImage*) image animated:(BOOL) animated {
  [activityView stopAnimating];
  imageView.image = image;

  if (animated) {
    [UIView beginAnimations:nil context:NULL];
  }

  imageLoadingView.alpha = 0;
  imageView.alpha = 1;

  if (animated) {
    [UIView commitAnimations];
  }
}


- (void) setNotFoundImage {
  [self setCellImage:[BoxOfficeStockImages imageNotAvailable] animated:YES];
}


- (void) setFoundImage:(UIImage*) image {
  imageLoaded = YES;

  CGSize imageSize = image.size;
  CGSize frameSize = imageView.frame.size;

  if (imageSize.height < frameSize.height) {
    imageView.contentMode = UIViewContentModeCenter;
  } else {
    imageView.contentMode = UIViewContentModeScaleAspectFill;
  }

  [self setCellImage:image animated:YES];
}


- (void) clearImage {
  [self startAnimating];

  imageLoaded = NO;
  imageView.image = nil;
  imageView.alpha = 0;
  imageLoadingView.alpha = 1;
}


- (void) loadImage {
  if (imageLoaded) {
    // we're done.  nothing else to do.
    return;
  }

  UIImage* image = [self loadImageWorker];
  if (image == nil) {
    [self prioritizeImage];

    if ([[OperationQueue operationQueue] hasPriorityOperations]) {
      [self clearImage];
    } else {
      [self setNotFoundImage];
    }
  } else {
    [self setFoundImage:image];
  }
}


- (NSArray*) allLabels AbstractMethod;


- (NSArray*) titleLabels AbstractMethod;


- (NSArray*) valueLabels AbstractMethod;


- (void) layoutSubviews {
  [super layoutSubviews];

  CGRect imageFrame = imageView.frame;

  CGRect titleFrame = titleLabel.frame;
  titleFrame.origin.x = (NSInteger)(imageFrame.size.width + 2);
  titleFrame.size.width = self.contentView.frame.size.width - titleFrame.origin.x;
  titleLabel.frame = titleFrame;

  for (UILabel* label in self.valueLabels) {
    CGRect frame = label.frame;
    frame.origin.x = (NSInteger)(imageFrame.size.width + 2 + titleWidth + 5);
    frame.size.width = self.contentView.frame.size.width - frame.origin.x;
    label.frame = frame;
  }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
  [super setSelected:selected animated:animated];

  if (selected) {
    titleLabel.textColor = [UIColor whiteColor];

    for (UILabel* label in self.allLabels) {
      label.textColor = [UIColor whiteColor];
    }
  } else {
    titleLabel.textColor = [UIColor blackColor];

    for (UILabel* label in self.allLabels) {
      label.textColor = [UIColor darkGrayColor];
    }
  }
}


- (UILabel*) createTitleLabel:(NSString*) title yPosition:(NSInteger) yPosition {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [UIColor darkGrayColor];
  label.text = title;
  label.textAlignment = UITextAlignmentRight;
  [label sizeToFit];
  CGRect frame = label.frame;
  frame.origin.y = yPosition;
  label.frame = frame;

  return label;
}


- (UILabel*) createValueLabel:(NSInteger) yPosition forTitle:(UILabel*) title {
  CGFloat height = title.frame.size.height;
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, height)] autorelease];
  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [UIColor darkGrayColor];

  return label;
}

@end
