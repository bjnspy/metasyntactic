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

#import "UpcomingMovieCell.h"

#import "Application.h"
#import "DateUtilities.h"
#import "ImageCache.h"
#import "Movie.h"
#import "NowPlayingModel.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"

@interface UpcomingMovieCell()
@property (retain) UILabel* titleLabel;
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;
@end


@implementation UpcomingMovieCell

@synthesize titleLabel;
@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedTitleLabel;
@synthesize genreTitleLabel;

@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratedLabel;
@synthesize genreLabel;

- (void) dealloc {
    self.titleLabel = nil;
    self.directorTitleLabel = nil;
    self.castTitleLabel = nil;
    self.ratedTitleLabel = nil;
    self.genreTitleLabel = nil;

    self.directorLabel = nil;
    self.castLabel = nil;
    self.ratedLabel = nil;
    self.genreLabel = nil;

    [super dealloc];
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


- (UILabel*) createValueLabel:(NSInteger) yPosition {
    CGFloat height = directorTitleLabel.frame.size.height;
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, height)] autorelease];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}


- (NSArray*) titleLabels {
    return [NSArray arrayWithObjects:
            directorTitleLabel,
            castTitleLabel,
            genreTitleLabel,
            ratedTitleLabel, nil];
}


- (NSArray*) valueLabels {
    return [NSArray arrayWithObjects:
            directorLabel,
            castLabel,
            genreLabel,
            ratedLabel, nil];
}


- (NSArray*) allLabels {
    return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_ {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier
                              model:model_]) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 20)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;

        self.directorTitleLabel = [self createTitleLabel:NSLocalizedString(@"Directors:", nil) yPosition:22];
        self.directorLabel = [self createValueLabel:22];

        self.castTitleLabel = [self createTitleLabel:NSLocalizedString(@"Cast:", nil) yPosition:37];
        self.castLabel = [self createValueLabel:37];
        castLabel.numberOfLines = 0;

        self.genreTitleLabel = [self createTitleLabel:NSLocalizedString(@"Genre:", nil) yPosition:67];
        self.genreLabel = [self createValueLabel:67];

        self.ratedTitleLabel = [self createTitleLabel:NSLocalizedString(@"Rated:", nil) yPosition:82];
        self.ratedLabel = [self createValueLabel:82];

        titleWidth = 0;
        for (UILabel* label in self.titleLabels) {
            titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
        }

        for (UILabel* label in self.titleLabels) {
            CGRect frame = label.frame;
            frame.size.width = titleWidth;
            frame.origin.x = (int)(imageView.frame.size.width + 7);
            label.frame = frame;
        }

        [self.contentView addSubview:titleLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = imageView.frame;

    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = (int)(imageFrame.size.width + 7);
    titleFrame.size.width = self.contentView.frame.size.width - titleFrame.origin.x;
    titleLabel.frame = titleFrame;

    for (UILabel* label in self.valueLabels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7 + titleWidth + 5);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }

    CGRect castFrame = castLabel.frame;
    CGSize size = [castLabel.text sizeWithFont:castLabel.font constrainedToSize:CGSizeMake(castFrame.size.width, 30) lineBreakMode:UILineBreakModeWordWrap];
    castFrame.size = size;
    castLabel.frame = castFrame;
}


- (void) loadMovie:(id) owner {
    [self loadImage];

    directorLabel.text  = [[model directorsForMovie:movie]  componentsJoinedByString:@", "];
    castLabel.text      = [[model castForMovie:movie]       componentsJoinedByString:@", "];
    genreLabel.text     = [[model genresForMovie:movie]     componentsJoinedByString:@", "];

    NSString* rating;
    if (movie.isUnrated) {		
        rating = NSLocalizedString(@"Not yet rated", nil);		
    } else {		
        rating = movie.rating;		
    }

    if ([owner sortingByTitle] || [model isBookmarkedUpcomingMovie:movie]) {
        NSString* releaseDate = [DateUtilities formatShortDate:movie.releaseDate];

        if (!movie.isUnrated) {
            releaseDate = [NSString stringWithFormat:NSLocalizedString(@"Release: %@", @"This is a shorter form of 'Release date:'. Used when there's less onscreen space."), releaseDate];
        }

        ratedLabel.text   = [NSString stringWithFormat:@"%@ - %@", rating, releaseDate];
    } else {
        ratedLabel.text = rating;
    }

    if (movie.directors.count <= 1) {
        directorTitleLabel.text = NSLocalizedString(@"Director:", nil);
    } else {
        directorTitleLabel.text = NSLocalizedString(@"Directors:", nil);
    }

    for (UILabel* label in self.allLabels) {
        [self.contentView addSubview:label];
    }

    [self setNeedsLayout];
}


- (void) setMovie:(Movie*) movie_
            owner:(id) owner {
    if ([model isBookmarkedUpcomingMovie:movie]) {
        titleLabel.text = [NSString stringWithFormat:@"%@ %@", [Application starString], movie.displayTitle];
    } else {
        titleLabel.text = movie.displayTitle;
    }
    
    if (movie == movie_) {
        [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadImage) object:nil];
        [self performSelector:@selector(loadImage) withObject:nil afterDelay:0];
    } else {
        self.movie = movie_;

        [self clearImage];

        for (UILabel* label in self.allLabels) {
            [label removeFromSuperview];
        }

        [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];
        [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
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

@end