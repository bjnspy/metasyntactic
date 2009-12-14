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

#import "ReviewTitleCell.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"
#import "Review.h"

@interface ReviewTitleCell()
@property (retain) UILabel* scoreLabel;
@end

@implementation ReviewTitleCell

@synthesize scoreLabel;

- (void) dealloc {
  self.scoreLabel = nil;

  [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
  if ((self = [super initWithStyle:UITableViewCellStyleSubtitle
                   reuseIdentifier:reuseIdentifier])) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.scoreLabel  = [[[UILabel alloc] init] autorelease];

    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textAlignment = UITextAlignmentCenter;

    [self.contentView addSubview:scoreLabel];

    // Hack.  For some reason, we can see the edge of this label peeking
    // beyond the edge of the cell.  So make it clear.
    self.textLabel.backgroundColor = [UIColor clearColor];
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (void) setImageWorker:(UIImage*) image {
  if (self.imageView.image != image) {
    self.imageView.image = image;
  }
}


- (void) layoutSubviews {
  [super layoutSubviews];
  [self.contentView bringSubviewToFront:scoreLabel];
}


- (void) clearScoreLabel {
  scoreLabel.text = nil;
  scoreLabel.frame = CGRectZero;
}


- (void) setBasicSquareImage:(NSInteger) score {
  if (score >= 0 && score <= 40) {
    [self setImageWorker:[BoxOfficeStockImages redRatingImage]];
  } else if (score > 40 && score <= 60) {
    [self setImageWorker:[BoxOfficeStockImages yellowRatingImage]];
  } else if (score > 60 && score <= 100) {
    [self setImageWorker:[BoxOfficeStockImages greenRatingImage]];
  } else {
    [self clearScoreLabel];
    [self setImageWorker:[BoxOfficeStockImages unknownRatingImage]];
  }

  if (score >= 0 && score <= 100) {
    CGRect frame = CGRectMake(6, 6, 30, 30);
    if (score == 100) {
      scoreLabel.font = [UIFont boldSystemFontOfSize:15];
    } else {
      scoreLabel.font = [FontCache boldSystem19];
    }

    scoreLabel.textColor = [ColorCache darkDarkGray];
    scoreLabel.frame = frame;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
  }
}


- (void) setGoogleImage:(NSInteger) score {
  [self setBasicSquareImage:(score == 0 ? -1 : score)];
}


- (void) setReviewImage:(Review*) review {
  NSInteger score = review.score;

  if ([Model model].rottenTomatoesScores) {
    [self setBasicSquareImage:score];
  } else if ([Model model].metacriticScores) {
    [self setBasicSquareImage:score];
  } else if ([Model model].googleScores) {
    [self setGoogleImage:score];
  }
}


- (void) setReview:(Review*) review {
  [self setReviewImage:review];

  if (review.author.length == 0) {
    self.textLabel.text = review.source;
    self.detailTextLabel.text = @"";
  } else {
    self.textLabel.text = review.author;
    self.detailTextLabel.text = review.source;
  }
}

@end
