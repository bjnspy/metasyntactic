// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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

        self.scoreLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textAlignment = UITextAlignmentCenter;

        self.titleLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;
        titleLabel.textColor = [UIColor blackColor];

        self.ratingLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        ratingLabel.font = [UIFont systemFontOfSize:12];
        ratingLabel.textColor = [UIColor grayColor];

        [self addSubview:titleLabel];
        [self addSubview:scoreLabel];
        [self addSubview:ratingLabel];
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


- (void) setScore:(Movie*) movie {
    {
        CGRect frame;
        if ([self.model noRatings]) {
            frame = CGRectMake(10, 25, 285, 12);
        } else {
            frame = CGRectMake(50, 25, 245, 12);
        }

        if (style == UITableViewStyleGrouped) {
            frame.origin.x += 10;
            frame.size.width -= 20;
        }

        self.ratingLabel.frame = frame;

        frame.origin.y = 5;
        frame.size.height = 20;
        self.titleLabel.frame = frame;
    }

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
    self.ratingLabel.text = [movie ratingAndRuntimeString];
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
