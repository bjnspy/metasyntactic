//
//  MovieShowtimesCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieShowtimesCell.h"

@implementation MovieShowtimesCell

@synthesize label;

- (void) dealloc {
    self.label = nil;
    [super dealloc];
}

- (id)    initWithFrame:(CGRect) frame
        reuseIdentifier:(NSString*) reuseIdentifier  {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {      
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];  
        
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:11];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.opaque = NO;
        
        [self addSubview:label];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.frame;
    CGRect labelBounds = CGRectMake(bounds.origin.x + 9, bounds.origin.y + 9, bounds.size.width - 10, bounds.size.height - 18);
    
    self.label.frame = labelBounds;
}

- (void) setShowtimes:(NSArray*) showtimes {
    NSMutableString* text = [NSMutableString stringWithString:[showtimes objectAtIndex:0]];
    
    for (int i = 1; i < [showtimes count]; i++) {
        [text appendString:@", "];
        [text appendString:[showtimes objectAtIndex:i]];
    }
    
    label.text = text;
}

@end