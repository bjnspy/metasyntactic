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

#import "Application.h"
#import "DVD.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "Model.h"
#import "Movie.h"

@interface DVDCell()
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* formatTitleLabel;
@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;
@property (retain) UILabel* formatLabel;
@end


@implementation DVDCell

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

- (void) dealloc {
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

    [super dealloc];
}


- (Model*) model {
    return [Model model];
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
            ratedTitleLabel,
            formatTitleLabel, nil];
}


- (NSArray*) valueLabels {
    return [NSArray arrayWithObjects:
            directorLabel,
            castLabel,
            genreLabel,
            ratedLabel,
            formatLabel, nil];
}


- (NSArray*) allLabels {
    return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (id) initWithReuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
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
            frame.origin.x = (int)(imageView.frame.size.width + 7);
            frame.size.width = titleWidth;
            label.frame = frame;
        }

        [self.contentView addSubview:titleLabel];
    }

    return self;
}


- (void) loadMovie:(id) owner {
    [self loadImage];

    DVD* dvd = [self.model dvdDetailsForMovie:movie];

    directorLabel.text  = [[self.model directorsForMovie:movie]  componentsJoinedByString:@", "];
    castLabel.text      = [[self.model castForMovie:movie]       componentsJoinedByString:@", "];
    genreLabel.text     = [[self.model genresForMovie:movie]     componentsJoinedByString:@", "];
    formatLabel.text    = dvd.format;

    NSString* rating;
    if (movie.isUnrated) {		
        rating = NSLocalizedString(@"Not yet rated", nil);		
    } else {		
        rating = movie.rating;		
    }

    if ([owner sortingByTitle] || [self.model isBookmarked:movie]) {
        NSString* releaseDate = [DateUtilities formatShortDate:movie.releaseDate];

        if (!movie.isUnrated) {
            releaseDate = [NSString stringWithFormat:NSLocalizedString(@"Release: %@", nil), releaseDate];
        }

        ratedLabel.text = [NSString stringWithFormat:@"%@ - %@", rating, releaseDate];
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
}

@end