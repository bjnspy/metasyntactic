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

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Model.h"
#import "Review.h"

@interface ReviewTitleCell()
@property (retain) UILabel* scoreLabel_;
@end

@implementation ReviewTitleCell

@synthesize scoreLabel_;

property_wrapper(UILabel*, scoreLabel, ScoreLabel);

- (void) dealloc {
    self.scoreLabel = nil;

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.scoreLabel  = [[[UILabel alloc] init] autorelease];

        self.scoreLabel.backgroundColor = [UIColor clearColor];
        self.scoreLabel.textAlignment = UITextAlignmentCenter;

        [self.contentView addSubview:self.scoreLabel];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}


- (void) layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:self.scoreLabel];
}


- (void) clearScoreLabel {
    self.scoreLabel.text = nil;
    self.scoreLabel.frame = CGRectZero;
}


- (void) setBasicSquareImage:(NSInteger) score {
    if (score >= 0 && score <= 40) {
        self.image = [ImageCache redRatingImage];
    } else if (score > 40 && score <= 60) {
        self.image = [ImageCache yellowRatingImage];
    } else if (score > 60 && score <= 100) {
        self.image = [ImageCache greenRatingImage];
    } else {
        [self clearScoreLabel];
        self.image = [ImageCache unknownRatingImage];
    }

    if (score >= 0 && score <= 100) {
        CGRect frame = CGRectMake(6, 6, 30, 30);
        if (score == 100) {
            self.scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        } else {
            self.scoreLabel.font = [FontCache boldSystem19];
        }

        self.scoreLabel.textColor = [ColorCache darkDarkGray];
        self.scoreLabel.frame = frame;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
}


- (void) setGoogleImage:(NSInteger) score {
    [self setBasicSquareImage:(score == 0 ? -1 : score)];
}


- (void) setReviewImage:(Review*) review {
    int score = review.score;

    if (self.model.rottenTomatoesScores) {
        [self setBasicSquareImage:score];
    } else if (self.model.metacriticScores) {
        [self setBasicSquareImage:score];
    } else if (self.model.googleScores) {
        [self setGoogleImage:score];
    }
}


- (void) setReview:(Review*) review {
    [self setReviewImage:review];

    self.textLabel.text = review.author;
    self.detailTextLabel.text = review.source;
}

@end