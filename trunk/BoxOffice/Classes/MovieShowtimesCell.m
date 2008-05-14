//
//  MovieShowtimesCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieShowtimesCell.h"

@implementation MovieShowtimesCell

@synthesize showtimes;

- (void) dealloc {
    self.showtimes = nil;
    [super dealloc];
}

- (id) initWithShowtimes: (NSArray*) showtimes_ {
    if (self = [super initWithFrame:CGRectZero reuseIdentifier:nil]) {
        self.showtimes = showtimes_;
    }
    
    return self;
}

+ (MovieShowtimesCell*) cellWithShowtimes:(NSArray*) showtimes {
    return [[[MovieShowtimesCell alloc] initWithShowtimes:showtimes] autorelease];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.frame;
    CGRect labelBounds = CGRectMake(bounds.origin.x + 9, bounds.origin.y + 9, bounds.size.width - 10, bounds.size.height - 18);
    
    NSString* text = [self.showtimes objectAtIndex:0];
    for (int i = 1; i < [self.showtimes count]; i++) {
        text = [text stringByAppendingString:@", "];
        text = [text stringByAppendingString:[self.showtimes objectAtIndex:i]];
    }
    
    UILabel* label = [[[UILabel alloc] initWithFrame:labelBounds] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:11];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.opaque = NO;
    
    [self addSubview:label];
}

@end