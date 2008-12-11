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
#import "NowPlayingModel.h"
#import "Review.h"

@interface ReviewTitleCell()
@property (retain) NowPlayingModel* model;
@property (retain) UILabel* scoreLabel;
@property (retain) UILabel* authorLabel;
@property (retain) UILabel* sourceLabel;
@end

@implementation ReviewTitleCell

@synthesize model;
@synthesize authorLabel;
@synthesize scoreLabel;
@synthesize sourceLabel;

- (void) dealloc {
    self.model = nil;
    self.authorLabel = nil;
    self.scoreLabel = nil;
    self.sourceLabel = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_
               frame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.authorLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.sourceLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.scoreLabel  = [[[UILabel alloc] initWithFrame:frame] autorelease];

        authorLabel.font = [UIFont boldSystemFontOfSize:14];
        sourceLabel.font = [UIFont systemFontOfSize:12];

        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        [self.contentView addSubview:authorLabel];
        [self.contentView addSubview:sourceLabel];
        [self addSubview:scoreLabel];
    }
    return self;
}


- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}


- (void) clearScoreLabel {
    scoreLabel.text = nil;
    scoreLabel.frame = CGRectZero;
}


- (void) setRottenTomatoesImage:(NSInteger) score {
    [self clearScoreLabel];

    if (score >= 60) {
        self.image = [ImageCache freshImage];
    } else {
        self.image = [ImageCache rottenFullImage];
    }
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
        CGRect frame = CGRectMake(20, 7, 30, 30);
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
    int score = review.score;

    if (model.rottenTomatoesScores) {
        [self setRottenTomatoesImage:score];
    } else if (model.metacriticScores) {
        [self setBasicSquareImage:score];
    } else if (model.googleScores) {
        [self setGoogleImage:score];
    }
}


- (void) setReview:(Review*) review {
    [self setReviewImage:review];

    authorLabel.text = review.author;
    sourceLabel.text = review.source;

    [authorLabel sizeToFit];
    [sourceLabel sizeToFit];

    CGRect frame;

    frame = authorLabel.frame;
    frame.origin.y = 5;
    frame.origin.x = 50;
    authorLabel.frame = frame;

    frame = sourceLabel.frame;
    frame.origin.y = 23;
    frame.origin.x = 50;
    sourceLabel.frame = frame;
}

@end