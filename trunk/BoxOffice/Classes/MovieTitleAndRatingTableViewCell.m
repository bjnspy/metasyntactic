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

- (id) initWithFrame:(CGRect) frame
               movie:(Movie*) movie_
{
	if (self = [super initWithFrame:frame reuseIdentifier:nil])
    {
        self.movie = movie_;
        
        int ratingValue = [self.movie.rating intValue];
        if (ratingValue >= 0 && ratingValue <= 100)
        {
            self.imageView = [[[RatingsView alloc] initWithFrame:CGRectZero rating:ratingValue] autorelease];
            
            self.imageView.opaque = NO;
            [self.contentView addSubview:self.imageView];
        }
		
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.label.text = movie.title;
        self.label.opaque = NO;
        [self.contentView addSubview:self.label];
	}
    
	return self;
}

- (void)dealloc
{
    self.movie = nil;
    self.label = nil;
    self.imageView = nil;
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	CGRect contentRect = self.contentView.bounds;
    
	CGRect imageRect = contentRect;
	imageRect.size = CGSizeMake(44, 32);
	self.imageView.frame = CGRectOffset(imageRect, 6, 6);
    
	// position the elment name in the content rect
	CGRect labelRect = contentRect;
	labelRect.origin.x += labelRect.origin.x+56;
    labelRect.size.width -= 56 ;
	label.frame = labelRect;
    label.font = [UIFont boldSystemFontOfSize:18];
}

@end
