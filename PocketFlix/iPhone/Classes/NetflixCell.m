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

#import "NetflixCell.h"

#import "Application.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "Model.h"
#import "TappableImageView.h"

@interface NetflixCell()
@property (retain) UILabel* directorTitleLabel;
@property (retain) UILabel* castTitleLabel;
@property (retain) UILabel* ratedTitleLabel;
@property (retain) UILabel* genreTitleLabel;
@property (retain) UILabel* netflixTitleLabel;
@property (retain) UILabel* directorLabel;
@property (retain) UILabel* castLabel;
@property (retain) UILabel* genreLabel;
@property (retain) UILabel* ratedLabel;
@property (retain) UILabel* netflixLabel;
@property (retain) UILabel* availabilityLabel;
@property (retain) UILabel* formatsLabel;
@property (retain) TappableImageView* tappableArrow;
@end


@implementation NetflixCell

@synthesize directorTitleLabel;
@synthesize castTitleLabel;
@synthesize ratedTitleLabel;
@synthesize genreTitleLabel;
@synthesize netflixTitleLabel;

@synthesize directorLabel;
@synthesize castLabel;
@synthesize ratedLabel;
@synthesize genreLabel;
@synthesize netflixLabel;
@synthesize availabilityLabel;
@synthesize formatsLabel;

@synthesize tappableArrow;

- (void) dealloc {
    self.directorTitleLabel = nil;
    self.castTitleLabel = nil;
    self.ratedTitleLabel = nil;
    self.genreTitleLabel = nil;
    self.netflixTitleLabel = nil;

    self.directorLabel = nil;
    self.castLabel = nil;
    self.ratedLabel = nil;
    self.genreLabel = nil;
    self.netflixLabel = nil;

    self.availabilityLabel = nil;
    self.formatsLabel = nil;

    tappableArrow.delegate = nil;
    self.tappableArrow = nil;

    [super dealloc];
}



- (NSArray*) titleLabels {
    return [NSArray arrayWithObjects:
            directorTitleLabel,
            castTitleLabel,
            genreTitleLabel,
            ratedTitleLabel,
            netflixTitleLabel, nil];
}


- (NSArray*) valueLabels {
    return [NSArray arrayWithObjects:
            directorLabel,
            castLabel,
            genreLabel,
            ratedLabel,
            netflixLabel,
            availabilityLabel,
            formatsLabel,
            nil];
}


- (NSArray*) allLabels {
    return [self.titleLabels arrayByAddingObjectsFromArray:self.valueLabels];
}


- (void) setupTappableArrow {
    UIImage* image = [ImageCache upArrow];
    TappableImageView* view = [[[TappableImageView alloc] initWithImage:image] autorelease];
    view.contentMode = UIViewContentModeCenter;

    CGRect frame = view.frame;
    frame.size.height += 80;
    view.frame = frame;

    self.tappableArrow = view;
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier
               model:(Model*) model_ {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier
                              model:model_]) {
        self.directorTitleLabel = [self createTitleLabel:NSLocalizedString(@"Directors:", nil) yPosition:22];
        self.directorLabel = [self createValueLabel:22 forTitle:directorTitleLabel];

        self.castTitleLabel = [self createTitleLabel:NSLocalizedString(@"Cast:", nil) yPosition:37];
        self.castLabel = [self createValueLabel:37 forTitle:castTitleLabel];

        self.genreTitleLabel = [self createTitleLabel:NSLocalizedString(@"Genre:", nil) yPosition:52];
        self.genreLabel = [self createValueLabel:52 forTitle:genreTitleLabel];

        self.ratedTitleLabel = [self createTitleLabel:NSLocalizedString(@"Rated:", nil) yPosition:67];
        self.ratedLabel = [self createValueLabel:67 forTitle:ratedTitleLabel];

        self.netflixTitleLabel = [self createTitleLabel:NSLocalizedString(@"Netflix:", nil) yPosition:82];
        self.netflixLabel = [self createValueLabel:81 forTitle:netflixTitleLabel];
        netflixLabel.font = [UIFont systemFontOfSize:17];

        self.availabilityLabel = [self createValueLabel:67 forTitle:ratedTitleLabel];
        self.formatsLabel = [self createValueLabel:81 forTitle:netflixTitleLabel];

        titleWidth = 0;
        for (UILabel* label in self.titleLabels) {
            titleWidth = MAX(titleWidth, [label.text sizeWithFont:label.font].width);
        }

        for (UILabel* label in self.titleLabels) {
            CGRect frame = label.frame;
            frame.origin.x = (int)(imageView.frame.size.width + 2);
            frame.size.width = titleWidth;
            label.frame = frame;
        }

        [self setupTappableArrow];
    }

    return self;
}


- (void) setNetflixLabel {
    NSMutableString* result = [NSMutableString string];
    NSString* rating = [model.netflixCache userRatingForMovie:movie];
    if (rating.length > 0) {
        userRating = YES;
    } else {
        userRating = NO;
        rating = [model.netflixCache netflixRatingForMovie:movie];
    }

    if (rating.length == 0) {
        netflixLabel.text = @"";
        return;
    }

    CGFloat score = [rating floatValue];

    for (int i = 0; i < 5; i++) {
        CGFloat value = score - i;
        if (value <= 0) {
            [result appendString:[Application emptyStarString]];
        } else if (value >= 1) {
            [result appendString:[Application starString]];
        } else {
            [result appendString:[Application halfStarString]];
        }
    }

    netflixLabel.text = result;
}


- (void) setNetflixLabelColor {
    if (userRating) {
        netflixLabel.textColor = [ColorCache starYellow];
    } else {
        netflixLabel.textColor = [UIColor redColor];
    }
}


- (void) loadMovie:(id) owner {
    [self loadImage];

    directorLabel.text  = [[model directorsForMovie:movie]  componentsJoinedByString:@", "];
    castLabel.text      = [[model castForMovie:movie]       componentsJoinedByString:@", "];
    genreLabel.text     = [[model genresForMovie:movie]     componentsJoinedByString:@", "];
    formatsLabel.text   = [[[[model.netflixCache formatsForMovie:movie] sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@"/"] stringByReplacingOccurrencesOfString:@"/i" withString:@"/I"];
    availabilityLabel.text = [model.netflixCache availabilityForMovie:movie];

    NSString* rating;
    if (movie.isUnrated) {		
        rating = NSLocalizedString(@"Unrated", nil);		
    } else {		
        rating = movie.rating;		
    }

    ratedLabel.text = rating;

    if (movie.directors.count <= 1) {
        directorTitleLabel.text = NSLocalizedString(@"Director:", nil);
    } else {
        directorTitleLabel.text = NSLocalizedString(@"Directors:", nil);
    }

    [self setNetflixLabel];
    [self setNetflixLabelColor];

    for (UILabel* label in self.allLabels) {
        [self.contentView addSubview:label];
    }

    [self setNeedsLayout];
}


- (void) refresh {
    [self loadMovie:nil];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];

    if (selected) {
    } else {
        [self setNetflixLabelColor];
    }
}


- (void) onSetSameMovie:(Movie*) movie_
                   owner:(id) owner  {
    [super onSetSameMovie:movie_ owner:owner];

    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];
    [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    [availabilityLabel sizeToFit];
    [formatsLabel sizeToFit];

    CGRect frame = self.frame;

    {
        CGRect formatFrame = formatsLabel.frame;
        formatFrame.origin.x = frame.size.width - formatFrame.size.width - 5;
        formatsLabel.frame = formatFrame;
    }

    {
        CGRect availabilityFrame = availabilityLabel.frame;
        availabilityFrame.origin.x = frame.size.width - availabilityFrame.size.width - 5;
        availabilityLabel.frame = availabilityFrame;
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    [UIView beginAnimations:nil context:NULL];
    {
        if (editing) {
            availabilityLabel.alpha = 0;
            formatsLabel.alpha = 0;
        } else {
            availabilityLabel.alpha = 1;
            formatsLabel.alpha = 1;
        }
    }
    [UIView commitAnimations];
}

@end