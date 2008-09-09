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
    label.text = title;
    label.textAlignment = UITextAlignmentRight;
    [label sizeToFit];
    
    return label;
}


- (UILabel*) createValueLabel:(NSInteger) yPosition {
    UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, yPosition, 0, 0)] autorelease];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame model:model_ movie:movie_]) {        
        self.ratedTitleLabel = [self createTitleLabel:NSLocalizedString(@"Rated:", nil) yPosition:5];
        self.ratedLabel = [self createValueLabel:ratedTitleLabel.frame.origin.y];
        if (movie.isUnrated) {
            ratedLabel.text = NSLocalizedString(@"Unrated.", nil);
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
