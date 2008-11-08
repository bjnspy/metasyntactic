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

#import "DVDCell.h"

#import "DateUtilities.h"
#import "DVD.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "ImageCache.h"
#import "Movie.h"
#import "NowPlayingModel.h"

@implementation DVDCell

@synthesize model;
@synthesize titleLabel;

@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedTitleLabel;
@synthesize genreTitleLabel;
@synthesize formatTitleLabel;

@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratedLabel;
@synthesize genreLabel;
@synthesize formatLabel;

@synthesize imageView;

- (void) dealloc {
    self.model = nil;
    self.titleLabel = nil;

    self.directorTitleLabel = nil;
    self.castTitleLabel = nil;
    self.ratedTitleLabel = nil;
    self.genreTitleLabel = nil;
    self.formatTitleLabel = nil;

    self.directorLabel = nil;
    self.castLabel = nil;
    self.ratedLabel = nil;
    self.genreLabel = nil;
    self.formatLabel = nil;

    self.imageView = nil;

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
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, 0)] autorelease];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}


- (NSArray*) titleLabels {
    return [NSArray arrayWithObjects:
            directorTitleLabel,
            castTitleLabel,
            genreTitleLabel,
            ratedTitleLabel,
            formatTitleLabel, nil];
}


- (NSArray*) labels {
    return [NSArray arrayWithObjects:
            directorLabel,
            castLabel,
            genreLabel,
            ratedLabel,
            formatLabel, nil];
}


- (NSArray*) allLabels {
    return [self.titleLabels arrayByAddingObjectsFromArray:self.labels];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(NowPlayingModel*) model_ {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.model = model_;

        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 20)] autorelease];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 14;

        self.directorTitleLabel = [self createTitleLabel:NSLocalizedString(@"Directors:", nil) yPosition:22];
        self.directorLabel = [self createValueLabel:22];

        self.castTitleLabel = [self createTitleLabel:NSLocalizedString(@"Cast:", nil) yPosition:37];
        self.castLabel = [self createValueLabel:37];

        self.genreTitleLabel = [self createTitleLabel:NSLocalizedString(@"Genre:", nil) yPosition:52];
        self.genreLabel = [self createValueLabel:52];

        self.ratedTitleLabel = [self createTitleLabel:NSLocalizedString(@"Rated:", nil) yPosition:67];
        self.ratedLabel = [self createValueLabel:67];

        self.formatTitleLabel = [self createTitleLabel:NSLocalizedString(@"Format:", nil) yPosition:82];
        self.formatLabel = [self createValueLabel:82];

        titleWidth = 0;
        for (UILabel* label in self.titleLabels) {
            titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
        }
        for (UILabel* label in self.titleLabels) {
            CGRect frame = label.frame;
            frame.size.width = titleWidth;
            label.frame = frame;
        }

        self.imageView = [[[UIImageView alloc] initWithImage:[ImageCache imageNotAvailable]] autorelease];

        for (UILabel* label in self.allLabels) {
            [self.contentView addSubview:label];
        }

        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:imageView];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = imageView.frame;
    if (imageFrame.size.height >= 100) {
        imageFrame.size.width *= 99.0 / imageFrame.size.height;
        imageFrame.size.height = 99.0;
    }
    imageView.frame = imageFrame;

    for (UILabel* label in self.titleLabels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7);
        label.frame = frame;
    }

    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = (int)(imageFrame.size.width + 7);
    titleFrame.size.width = self.contentView.frame.size.width - titleFrame.origin.x;
    titleLabel.frame = titleFrame;

    for (UILabel* label in self.labels) {
        CGRect frame = label.frame;
        frame.origin.x = (int)(imageFrame.size.width + 7 + titleWidth + 5);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        label.frame = frame;
    }
}


- (void) setMovie:(Movie*) movie owner:(id) owner {
    DVD* dvd = [model.dvdCache detailsForMovie:movie];

    titleLabel.text = movie.displayTitle;
    directorLabel.text  = [[model directorsForMovie:movie]  componentsJoinedByString:@", "];
    castLabel.text      = [[model castForMovie:movie]       componentsJoinedByString:@", "];
    genreLabel.text     = [[model genresForMovie:movie]     componentsJoinedByString:@", "];
    formatLabel.text    = dvd.format;

    NSString* rating;
    if (movie.isUnrated) {		
        rating = NSLocalizedString(@"Not yet rated", nil);		
    } else {		
        rating = movie.rating;		
    }

    if ([owner sortingByTitle]) {
        NSString* releaseDate = [DateUtilities formatShortDate:movie.releaseDate];

        if (!movie.isUnrated) {
            releaseDate = [NSString stringWithFormat:NSLocalizedString(@"Release: %@", nil), releaseDate];
        }

        ratedLabel.text   = [NSString stringWithFormat:@"%@ - %@", rating, releaseDate];
    } else {
        ratedLabel.text = rating;
    }

    UIImage* image = [model posterForMovie:movie];
    if (image == nil) {
        [model.dvdCache prioritizeMovie:movie];
        imageView.image = [ImageCache imageNotAvailable];
    } else {
        imageView.image = image;
    }

    if (movie.directors.count == 1) {
        directorTitleLabel.text = NSLocalizedString(@"Director:", nil);
    } else {
        directorTitleLabel.text = NSLocalizedString(@"Directors:", nil);
    }

    [ratedLabel sizeToFit];
    [directorLabel sizeToFit];
    [genreLabel sizeToFit];
    [formatLabel sizeToFit];
    [castLabel sizeToFit];
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