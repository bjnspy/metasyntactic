//
//  MovieTitleCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/14/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieTitleCell.h"
#import "Application.h"
#import "ImageCache.h"
#import "FontCache.h"
#import "ColorCache.h"

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
        titleLabel.minimumFontSize = 16;
        titleLabel.textColor = [UIColor blackColor];

        self.ratingLabel = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        ratingLabel.font = [UIFont systemFontOfSize:12];
        ratingLabel.textColor = [UIColor grayColor];

        {
            CGRect frame = CGRectMake(50, 25, 250, 12);

            if (style == UITableViewStyleGrouped) {
                frame.origin.x += 10;
                frame.size.width -= 20;
            }

            self.ratingLabel.frame = frame;

            frame.origin.y = 5;
            frame.size.height = 20;
            self.titleLabel.frame = frame;
        }

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
    if ([self.model rottenTomatoesRatings]) {
        [self setRottenTomatoesScore:movie];
    } else {
        [self setMetacriticScore:movie];
    }
}

- (void) setMovie:(Movie*) movie {
    [self setScore:movie];
    self.ratingLabel.text = [movie ratingAndRuntimeString];
    self.titleLabel.text = movie.title;
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
