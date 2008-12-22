//
//  NetflixCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixCell.h"

#import "Application.h"
#import "ColorCache.h"
#import "DVD.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "NowPlayingModel.h"

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
            ratedTitleLabel,
            netflixTitleLabel, nil];
}


- (NSArray*) valueLabels {
    return [NSArray arrayWithObjects:
            directorLabel,
            castLabel,
            genreLabel,
            ratedLabel,
            netflixLabel, nil];
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
        
        self.netflixTitleLabel = [self createTitleLabel:NSLocalizedString(@"Netflix:", nil) yPosition:82];
        self.netflixLabel = [self createValueLabel:81];
        netflixLabel.font = [UIFont systemFontOfSize:17];        
        
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
        netflixLabel.textColor = [ColorCache netflixYellow];
    } else {
        netflixLabel.textColor = [UIColor redColor];
    }
}


- (void) loadMovie:(id) owner {
    [self loadImage];
    
    directorLabel.text  = [[model directorsForMovie:movie]  componentsJoinedByString:@", "];
    castLabel.text      = [[model castForMovie:movie]       componentsJoinedByString:@", "];
    genreLabel.text     = [[model genresForMovie:movie]     componentsJoinedByString:@", "];

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
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    
    if (!selected) {
        [self setNetflixLabelColor];
    }
}


- (void) onSetSameMovie:(Movie*) movie_
                   owner:(id) owner  {
    [super onSetSameMovie:movie_ owner:owner];
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadMovie:) object:owner];
    [self performSelector:@selector(loadMovie:) withObject:owner afterDelay:0];
}

@end
