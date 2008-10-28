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

#import "ExpandedMovieDetailsCell.h"

#import "DateUtilities.h"
#import "Movie.h"
#import "NowPlayingModel.h"

@implementation ExpandedMovieDetailsCell

@synthesize ratedTitleLabel;
@synthesize runningTimeTitleLabel;
@synthesize releaseDateTitleLabel;
@synthesize genreTitleLabel;
@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedLabel;
@synthesize runningTimeLabel;
@synthesize releaseDateLabel;
@synthesize genreLabel;
@synthesize directorLabel;
@synthesize castLabels;

- (void) dealloc {
    self.ratedTitleLabel = nil;
    self.runningTimeTitleLabel = nil;
    self.releaseDateTitleLabel = nil;
    self.genreTitleLabel = nil;
    self.directorTitleLabel = nil;
    self.castTitleLabel = nil;
    self.ratedLabel = nil;
    self.runningTimeLabel = nil;
    self.releaseDateLabel = nil;
    self.genreLabel = nil;
    self.directorLabel = nil;
    self.castLabels = nil;

    [super dealloc];
}


- (UILabel*) createTitleLabel:(NSString*) title
                    yPosition:(NSInteger) yPosition {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, 0)] autorelease];

    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = UITextAlignmentRight;
    [label sizeToFit];

    return label;
}


- (UILabel*) createValueLabel:(NSInteger) yPosition {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, 0)] autorelease];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    return label;
}


- (void) addDisclosureTriangle {
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DownDisclosureTriangle.png"]] autorelease];
    CGRect frame = imageView.frame;
    frame.origin.x = 10;
    frame.origin.y = 3;
    imageView.frame = frame;

    [self.contentView addSubview:imageView];
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame model:model_ movie:movie_]) {
        self.ratedTitleLabel = [self createTitleLabel:NSLocalizedString(@"Rated:", nil) yPosition:5];
        self.ratedLabel = [self createValueLabel:ratedTitleLabel.frame.origin.y];
        if (movie.isUnrated) {
            ratedLabel.text = NSLocalizedString(@"Unrated", nil);
        } else {
            ratedLabel.text = movie.rating;
        }
        CGFloat titleFontSize = ratedTitleLabel.font.pointSize;
        CGFloat buffer = titleFontSize + 10;

        self.runningTimeTitleLabel = [self createTitleLabel:NSLocalizedString(@"Running time:", nil)
                                                  yPosition:ratedTitleLabel.frame.origin.y + buffer];
        self.runningTimeLabel = [self createValueLabel:runningTimeTitleLabel.frame.origin.y];
        runningTimeLabel.text = movie.runtimeString;

        self.releaseDateTitleLabel = [self createTitleLabel:NSLocalizedString(@"Release date:", nil)
                                                  yPosition:runningTimeTitleLabel.frame.origin.y + buffer];
        self.releaseDateLabel = [self createValueLabel:releaseDateTitleLabel.frame.origin.y];
        releaseDateLabel.text = [DateUtilities formatMediumDate:movie.releaseDate];

        self.genreTitleLabel = [self createTitleLabel:NSLocalizedString(@"Genre:", nil)
                                            yPosition:releaseDateTitleLabel.frame.origin.y + buffer];
        self.genreLabel = [self createValueLabel:genreTitleLabel.frame.origin.y];
        genreLabel.text = [[model genresForMovie:movie] componentsJoinedByString:@", "];

        self.directorTitleLabel = [self createTitleLabel:NSLocalizedString(@"Directors:", nil)
                                               yPosition:genreTitleLabel.frame.origin.y + buffer];
        self.directorLabel = [self createValueLabel:directorTitleLabel.frame.origin.y];
        directorLabel.text = [[model directorsForMovie:movie] componentsJoinedByString:@", "];
        if ([model directorsForMovie:movie].count == 1) {
            self.directorTitleLabel.text = NSLocalizedString(@"Director:", nil);
        }

        self.castTitleLabel = [self createTitleLabel:NSLocalizedString(@"Cast:", nil)
                                           yPosition:directorLabel.frame.origin.y + buffer];

        CGFloat yPosition = castTitleLabel.frame.origin.y;
        NSMutableArray* array = [NSMutableArray array];
        for (NSString* castMember in [model castForMovie:movie]) {
            UILabel* castLabel = [self createValueLabel:yPosition];
            castLabel.text = castMember;
            yPosition = castLabel.frame.origin.y + buffer;

            [array addObject:castLabel];
        }
        self.castLabels = array;

        NSArray* titleLabels = [NSArray arrayWithObjects:
                                ratedTitleLabel, runningTimeTitleLabel, releaseDateTitleLabel,
                                genreTitleLabel, directorTitleLabel, castTitleLabel, nil];
        NSArray* valueLabels = [[NSArray arrayWithObjects:
                                ratedLabel, runningTimeLabel, releaseDateLabel,
                                genreLabel, directorLabel, nil] arrayByAddingObjectsFromArray:castLabels];

        titleWidth = 0;
        for (UILabel* label in titleLabels) {
            titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
        }
        titleWidth += 20;

        for (UILabel* label in titleLabels) {
            CGRect frame = label.frame;
            frame.size.width = titleWidth;
            label.frame = frame;
        }
        for (UILabel* label in valueLabels) {
            [label sizeToFit];
            CGRect frame = label.frame;
            frame.origin.x = titleWidth + 7;
            label.frame = frame;
        }

        for (UILabel* label in [titleLabels arrayByAddingObjectsFromArray:valueLabels]) {
            [self.contentView addSubview:label];
        }

        [self addDisclosureTriangle];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    NSArray* valueLabels = [[NSArray arrayWithObjects:
                             ratedLabel, runningTimeLabel, releaseDateLabel,
                             genreLabel, directorLabel, nil] arrayByAddingObjectsFromArray:castLabels];

    for (UILabel* label in valueLabels) {
        CGRect frame = label.frame;
        frame.size.width = MIN(frame.size.width, self.contentView.frame.size.width - frame.origin.x);
        label.frame = frame;
    }
}


- (CGFloat) height:(UITableView*) tableView {
    UILabel* lastLabel;
    if (castLabels.count == 0) {
        lastLabel = castTitleLabel;
    } else {
        lastLabel = castLabels.lastObject;
    }

    return lastLabel.frame.origin.y + lastLabel.frame.size.height + 7;
}

@end