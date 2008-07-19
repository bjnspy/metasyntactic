//
//  MovieShowtimesCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/11/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieShowtimesCell.h"
#import "Performance.h"
#import "Application.h"

@implementation MovieShowtimesCell

@synthesize label;

- (void) dealloc {
    self.label = nil;
    [super dealloc];
}

+ (NSString*) showtimesString:(NSArray*) showtimes {
    NSMutableString* text = [NSMutableString stringWithString:[[showtimes objectAtIndex:0] time]];
    
    for (int i = 1; i < showtimes.count; i++) {
        [text appendString:@", "];
        Performance* performance = [showtimes objectAtIndex:i];
        [text appendString:performance.time];
    }
    
    return text;
}

+ (CGFloat) heightForShowtimes:(NSArray*) showtimes {
    NSString* string = [MovieShowtimesCell showtimesString:showtimes];
    
    return [string sizeWithFont:[Application boldSystem11]
              constrainedToSize:CGSizeMake(272, 1000)
                  lineBreakMode:UILineBreakModeWordWrap].height;
}

- (id)    initWithFrame:(CGRect) frame
        reuseIdentifier:(NSString*) reuseIdentifier  {
    if (self = [super initWithFrame:frame
                    reuseIdentifier:reuseIdentifier]) {
        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];  
        
        label.numberOfLines = 0;
        label.font = [Application boldSystem11];
        label.lineBreakMode = UILineBreakModeWordWrap;
        
        [self addSubview:label];
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.frame;
    CGRect labelBounds = CGRectMake(bounds.origin.x + 9, bounds.origin.y + 9, 272, bounds.size.height - 18);
    
    self.label.frame = labelBounds;
}

- (void) setShowtimes:(NSArray*) showtimes {
    label.text = [MovieShowtimesCell showtimesString:showtimes];
}

- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
}

@end