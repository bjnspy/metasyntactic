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

#import "MovieTitleCell.h"

#import "Application.h"
#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Movie.h"
#import "NowPlayingModel.h"

@interface MovieTitleCell()
@property (retain) NowPlayingModel* model;
@property (retain) UILabel* scoreLabel;
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* ratingLabel;
@end


@implementation MovieTitleCell

@synthesize scoreLabel;
@synthesize titleLabel;
@synthesize ratingLabel;
@synthesize model;

- (void) dealloc {
    self.scoreLabel = nil;
    self.titleLabel = nil;
    self.ratingLabel = nil;
    self.model = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_
               style:(UITableViewStyle) style_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;
        style = style_;

        self.scoreLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        self.titleLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;
        titleLabel.textColor = [UIColor blackColor];

        self.ratingLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        ratingLabel.font = [UIFont systemFontOfSize:12];
        ratingLabel.textColor = [UIColor grayColor];

        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:ratingLabel];
        [self addSubview:scoreLabel];
    }

    return self;
}


- (void) setImage:(UIImage*) image {
    if (self.image != image) {
        [super setImage:image];
    }
}


- (void) setRottenTomatoesScore:(Movie*) movie {
    int score = [model scoreValueForMovie:movie];

    if (score >= 0 && score <= 100) {
        if (score >= 60) {
            if (self.image != [ImageCache freshImage]) {
                self.image = [ImageCache freshImage];

                scoreLabel.font = [UIFont boldSystemFontOfSize:15];
                scoreLabel.textColor = [UIColor whiteColor];

                CGRect frame = CGRectMake(10, 8, 32, 32);
                if (style == UITableViewStyleGrouped) {
                    frame.origin.x += 10;
                }

                scoreLabel.frame = frame;
            }
        } else {
            if (self.image != [ImageCache rottenFadedImage]) {
                self.image = [ImageCache rottenFadedImage];

                scoreLabel.font = [UIFont boldSystemFontOfSize:17];
                scoreLabel.textColor = [UIColor blackColor];

                CGRect frame = CGRectMake(10, 6, 30, 32);
                if (style == UITableViewStyleGrouped) {
                    frame.origin.x += 10;
                }

                scoreLabel.frame = frame;
            }
        }

        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    } else {
        if (self.image != [ImageCache unknownRatingImage]) {
            scoreLabel.text = nil;
            self.image = [ImageCache unknownRatingImage];
        }
    }
}


- (void) setBasicSquareScore:(Movie*) movie {
    int score = [model scoreValueForMovie:movie];

    if (score >= 0 && score <= 100) {
        CGRect frame = CGRectMake(10, 7, 30, 30);
        if (score == 100) {
            scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        } else {
            scoreLabel.font = [FontCache boldSystem19];
        }

        if (style == UITableViewStyleGrouped) {
            frame.origin.x += 10;
        }

        scoreLabel.textColor = [ColorCache darkDarkGray];
        scoreLabel.frame = frame;
        scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }

    if (score >= 0 && score <= 40) {
        self.image = [ImageCache redRatingImage];
    } else if (score > 40 && score <= 60) {
        self.image = [ImageCache yellowRatingImage];
    } else if (score > 60 && score <= 100) {
        self.image = [ImageCache greenRatingImage];
    } else {
        self.scoreLabel.text = nil;
        self.image = [ImageCache unknownRatingImage];
    }
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame;
    if (model.noScores) {
        frame = CGRectMake(10, 25, 0, 14);
    } else {
        frame = CGRectMake(50, 25, 0, 14);
    }

    frame.size.width = self.contentView.frame.size.width - frame.origin.x;

    ratingLabel.frame = frame;

    frame.origin.y = 5;
    frame.size.height = 20;
    titleLabel.frame = frame;
}


- (void) setScore:(Movie*) movie {
    if (model.rottenTomatoesScores) {
        [self setRottenTomatoesScore:movie];
    } else if (model.metacriticScores) {
        [self setBasicSquareScore:movie];
    } else if (model.googleScores) {
        [self setBasicSquareScore:movie];
    } else if (model.noScores) {
        self.image = nil;
        scoreLabel.text = nil;
    }
}


- (void) setMovie:(Movie*) movie owner:(id) owner {
    [self setScore:movie];
    ratingLabel.text = movie.ratingAndRuntimeString;
    
    if ([model isBookmarkedMovie:movie]) {
        titleLabel.text = [NSString stringWithFormat:@"%@ %@", [Application starString], movie.displayTitle];
    } else {
        titleLabel.text = movie.displayTitle;
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        ratingLabel.textColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.textColor = [UIColor blackColor];
        ratingLabel.textColor = [UIColor grayColor];
    }
}

@end