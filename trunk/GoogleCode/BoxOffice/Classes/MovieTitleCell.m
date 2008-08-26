// Copyright (C) 2008 Cyrus Najmabadi
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

#import "MovieTitleCell.h"

#import "BoxOfficeModel.h"
#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Movie.h"

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
               model:(BoxOfficeModel*) model_
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
    int score = [self.model scoreForMovie:movie];

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
            self.scoreLabel.text = nil;
            self.image = [ImageCache unknownRatingImage];
        }
    }
}


- (void) setMetacriticScore:(Movie*) movie {
    int score = [self.model scoreForMovie:movie];

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
    if ([self.model noRatings]) {
        frame = CGRectMake(10, 25, 0, 14);
    } else {
        frame = CGRectMake(50, 25, 0, 14);
    }

    frame.size.width = self.contentView.frame.size.width - frame.origin.x;

    self.ratingLabel.frame = frame;

    frame.origin.y = 5;
    frame.size.height = 20;
    self.titleLabel.frame = frame;
}


- (void) setScore:(Movie*) movie {
    if ([self.model rottenTomatoesRatings]) {
        [self setRottenTomatoesScore:movie];
    } else if ([self.model metacriticRatings]) {
        [self setMetacriticScore:movie];
    } else if ([self.model noRatings]) {
        self.image = nil;
        self.scoreLabel.text = nil;
    }
}


- (void) setMovie:(Movie*) movie {
    [self setScore:movie];
    self.ratingLabel.text = movie.ratingAndRuntimeString;
    self.titleLabel.text = movie.displayTitle;
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
