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
@property (retain) UILabel* scoreLabel;
#ifndef IPHONE_OS_VERSION_3
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;
#endif
@end

@implementation ReviewTitleCell

@synthesize scoreLabel;
#ifndef IPHONE_OS_VERSION_3
@synthesize textLabel;
@synthesize detailTextLabel;
#endif

- (void) dealloc {
    self.scoreLabel = nil;
#ifndef IPHONE_OS_VERSION_3
    self.textLabel = nil;
    self.detailTextLabel = nil;
#endif

    [super dealloc];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier {
#ifdef IPHONE_OS_VERSION_3
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:reuseIdentifier]) {
#else
    if (self = [super initWithFrame:CGRectZero
                    reuseIdentifier:reuseIdentifier]) {
#endif
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.scoreLabel  = [[[UILabel alloc] init] autorelease];

        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        [self.contentView addSubview:scoreLabel];

#ifndef IPHONE_OS_VERSION_3
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

        textLabel.font = [UIFont boldSystemFontOfSize:14];
        detailTextLabel.font = [UIFont systemFontOfSize:12];

        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:detailTextLabel];
#else
        // Hack.  For some reason, we can see the edge of this label peeking
        // beyond the edge of the cell.  So make it clear.
        self.textLabel.backgroundColor = [UIColor clearColor];
#endif
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
    [self.contentView bringSubviewToFront:scoreLabel];
}


- (void) clearScoreLabel {
    scoreLabel.text = nil;
    scoreLabel.frame = CGRectZero;
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
#ifdef IPHONE_OS_VERSION_3
        CGRect frame = CGRectMake(6, 6, 30, 30);
#else
        CGRect frame = CGRectMake(10, 7, 30, 30);
#endif
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

#ifndef IPHONE_OS_VERSION_3
    [textLabel sizeToFit];
    [detailTextLabel sizeToFit];

    CGRect frame;

    frame = textLabel.frame;
    frame.origin.y = 5;
    frame.origin.x = 50;
    textLabel.frame = frame;

    frame = detailTextLabel.frame;
    frame.origin.y = 23;
    frame.origin.x = 50;
    detailTextLabel.frame = frame;
#endif
}

@end