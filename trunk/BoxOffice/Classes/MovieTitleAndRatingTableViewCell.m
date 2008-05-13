//
//  MovieTitleAndRatingTableViewCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieTitleAndRatingTableViewCell.h"
#import "RatingsView.h"

@implementation MovieTitleAndRatingTableViewCell

@synthesize movie;
@synthesize label;
@synthesize imageView;

- (void) dealloc {
    self.movie = nil;
    self.label = nil;
    self.imageView = nil;
    [super dealloc];
}

+ (NSString*) identifier {
    return @"MovieTitleAndRatingTableViewCellReuseIdentifier";
}

- (id) initWithMovie:(Movie*) movie_ {
    if (self = [super initWithFrame:[UIScreen mainScreen].applicationFrame
                    reuseIdentifier:[MovieTitleAndRatingTableViewCell identifier]]) {
        self.movie = movie_;
        
        self.imageView = [[[RatingsView alloc] initWithFrame:CGRectZero
                                                      rating:[self.movie ratingValue]] autorelease];
        
        self.imageView.opaque = NO;
        [self.contentView addSubview:self.imageView];
        
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.label.text = movie.title;
        self.label.opaque = NO;
        self.label.font = [UIFont boldSystemFontOfSize:18];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumFontSize = 14;
        
        [self.contentView addSubview:self.label];
    }
    
    return self;
}

+ (MovieTitleAndRatingTableViewCell*) cell:(Movie*) movie {
    return [[[MovieTitleAndRatingTableViewCell alloc] initWithMovie:movie] autorelease];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    
    CGRect imageRect = contentRect;
    imageRect.size = CGSizeMake(40, 32);
    self.imageView.frame = CGRectOffset(imageRect, 6, 5);
    
    CGRect labelRect = contentRect;
    labelRect.origin.x += 52;
    labelRect.size.width -= 52;
    label.frame = labelRect;
}

@end
